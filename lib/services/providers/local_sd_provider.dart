import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../provider_base.dart';

/// The type of local Stable Diffusion backend.
enum LocalSDType {
  automatic1111,
  comfyUI,
}

/// Image generation provider for a locally-running Stable Diffusion instance.
///
/// Supports both Automatic1111 WebUI and ComfyUI backends.
class LocalSDProvider implements ImageGenerationProvider {
  /// Creates a provider that connects to a local SD instance.
  ///
  /// [endpoint] defaults to `http://localhost:7860`.
  /// [type] specifies which backend API to target.
  LocalSDProvider({
    this.endpoint = 'http://localhost:7860',
    this.type = LocalSDType.automatic1111,
  });

  /// The base URL of the local Stable Diffusion server.
  final String endpoint;

  /// Which backend API dialect to use.
  final LocalSDType type;

  @override
  String get name => type == LocalSDType.automatic1111
      ? 'Local SD (Automatic1111)'
      : 'Local SD (ComfyUI)';

  @override
  String get id =>
      type == LocalSDType.automatic1111 ? 'automatic1111' : 'comfyUI';

  @override
  Future<bool> checkAvailability() async {
    try {
      final url = type == LocalSDType.automatic1111
          ? '$endpoint/sdapi/v1/sd-models'
          : '$endpoint/system_stats';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Uint8List> generateImage({
    required String prompt,
    String? negativePrompt,
    required int width,
    required int height,
    int steps = 30,
    double guidanceScale = 7.5,
    String? loraModel,
  }) async {
    switch (type) {
      case LocalSDType.automatic1111:
        return _generateAutomatic1111(
          prompt: prompt,
          negativePrompt: negativePrompt,
          width: width,
          height: height,
          steps: steps,
          guidanceScale: guidanceScale,
          loraModel: loraModel,
        );
      case LocalSDType.comfyUI:
        return _generateComfyUI(
          prompt: prompt,
          negativePrompt: negativePrompt,
          width: width,
          height: height,
          steps: steps,
          guidanceScale: guidanceScale,
          loraModel: loraModel,
        );
    }
  }

  /// Generates an image using the Automatic1111 WebUI API.
  Future<Uint8List> _generateAutomatic1111({
    required String prompt,
    String? negativePrompt,
    required int width,
    required int height,
    required int steps,
    required double guidanceScale,
    String? loraModel,
  }) async {
    final effectivePrompt =
        loraModel != null ? '<lora:$loraModel:0.8> $prompt' : prompt;

    final body = jsonEncode({
      'prompt': effectivePrompt,
      'negative_prompt': negativePrompt ?? '',
      'width': width,
      'height': height,
      'steps': steps,
      'cfg_scale': guidanceScale,
      'sampler_name': 'DPM++ 2M Karras',
      'batch_size': 1,
      'n_iter': 1,
    });

    final http.Response response;
    try {
      response = await http
          .post(
            Uri.parse('$endpoint/sdapi/v1/txt2img'),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(minutes: 5));
    } catch (e) {
      throw LocalSDException(
        'Failed to connect to Automatic1111 at $endpoint: $e',
      );
    }

    if (response.statusCode != 200) {
      throw LocalSDException(
        'Automatic1111 API error (${response.statusCode}): ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final images = json['images'] as List<dynamic>?;

    if (images == null || images.isEmpty) {
      throw LocalSDException('No images returned from Automatic1111.');
    }

    final base64Image = images[0] as String;
    return base64Decode(base64Image);
  }

  /// Generates an image using the ComfyUI API.
  ///
  /// This is a simplified implementation that submits a basic workflow,
  /// polls for completion, and downloads the result.
  Future<Uint8List> _generateComfyUI({
    required String prompt,
    String? negativePrompt,
    required int width,
    required int height,
    required int steps,
    required double guidanceScale,
    String? loraModel,
  }) async {
    // Build a minimal ComfyUI workflow for txt2img.
    final workflow = _buildComfyWorkflow(
      prompt: loraModel != null ? '<lora:$loraModel:0.8> $prompt' : prompt,
      negativePrompt: negativePrompt ?? '',
      width: width,
      height: height,
      steps: steps,
      guidanceScale: guidanceScale,
    );

    final body = jsonEncode({'prompt': workflow});

    // Submit the workflow.
    final http.Response queueResponse;
    try {
      queueResponse = await http
          .post(
            Uri.parse('$endpoint/api/prompt'),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw LocalSDException(
        'Failed to connect to ComfyUI at $endpoint: $e',
      );
    }

    if (queueResponse.statusCode != 200) {
      throw LocalSDException(
        'ComfyUI queue error (${queueResponse.statusCode}): '
        '${queueResponse.body}',
      );
    }

    final queueJson =
        jsonDecode(queueResponse.body) as Map<String, dynamic>;
    final promptId = queueJson['prompt_id'] as String?;

    if (promptId == null) {
      throw LocalSDException('No prompt_id returned from ComfyUI.');
    }

    // Poll for completion.
    return _pollComfyResult(promptId);
  }

  /// Polls the ComfyUI history endpoint until the prompt completes,
  /// then downloads the output image.
  Future<Uint8List> _pollComfyResult(String promptId) async {
    const maxAttempts = 120; // up to ~10 minutes at 5-second intervals
    const pollInterval = Duration(seconds: 5);

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      await Future<void>.delayed(pollInterval);

      final http.Response historyResponse;
      try {
        historyResponse = await http
            .get(Uri.parse('$endpoint/history/$promptId'))
            .timeout(const Duration(seconds: 10));
      } catch (_) {
        continue; // Retry on transient failure.
      }

      if (historyResponse.statusCode != 200) continue;

      final historyJson =
          jsonDecode(historyResponse.body) as Map<String, dynamic>;
      final promptHistory =
          historyJson[promptId] as Map<String, dynamic>?;

      if (promptHistory == null) continue;

      final outputs = promptHistory['outputs'] as Map<String, dynamic>?;
      if (outputs == null || outputs.isEmpty) continue;

      // Find the first output node with images.
      for (final nodeOutput in outputs.values) {
        final nodeMap = nodeOutput as Map<String, dynamic>;
        final images = nodeMap['images'] as List<dynamic>?;
        if (images != null && images.isNotEmpty) {
          final imageInfo = images[0] as Map<String, dynamic>;
          final filename = imageInfo['filename'] as String;
          final subfolder = imageInfo['subfolder'] as String? ?? '';
          final imageType = imageInfo['type'] as String? ?? 'output';

          // Download the image.
          final imageUri = Uri.parse('$endpoint/view').replace(
            queryParameters: {
              'filename': filename,
              'subfolder': subfolder,
              'type': imageType,
            },
          );

          final imageResponse = await http
              .get(imageUri)
              .timeout(const Duration(seconds: 30));

          if (imageResponse.statusCode == 200) {
            return imageResponse.bodyBytes;
          }
        }
      }
    }

    throw LocalSDException(
      'ComfyUI generation timed out for prompt $promptId.',
    );
  }

  /// Builds a minimal ComfyUI workflow JSON for txt2img generation.
  Map<String, dynamic> _buildComfyWorkflow({
    required String prompt,
    required String negativePrompt,
    required int width,
    required int height,
    required int steps,
    required double guidanceScale,
  }) {
    return {
      '3': {
        'class_type': 'KSampler',
        'inputs': {
          'seed': DateTime.now().millisecondsSinceEpoch,
          'steps': steps,
          'cfg': guidanceScale,
          'sampler_name': 'dpmpp_2m',
          'scheduler': 'karras',
          'denoise': 1.0,
          'model': ['4', 0],
          'positive': ['6', 0],
          'negative': ['7', 0],
          'latent_image': ['5', 0],
        },
      },
      '4': {
        'class_type': 'CheckpointLoaderSimple',
        'inputs': {
          'ckpt_name': 'sd_xl_base_1.0.safetensors',
        },
      },
      '5': {
        'class_type': 'EmptyLatentImage',
        'inputs': {
          'width': width,
          'height': height,
          'batch_size': 1,
        },
      },
      '6': {
        'class_type': 'CLIPTextEncode',
        'inputs': {
          'text': prompt,
          'clip': ['4', 1],
        },
      },
      '7': {
        'class_type': 'CLIPTextEncode',
        'inputs': {
          'text': negativePrompt,
          'clip': ['4', 1],
        },
      },
      '8': {
        'class_type': 'VAEDecode',
        'inputs': {
          'samples': ['3', 0],
          'vae': ['4', 2],
        },
      },
      '9': {
        'class_type': 'SaveImage',
        'inputs': {
          'filename_prefix': 'crimson_eclipse',
          'images': ['8', 0],
        },
      },
    };
  }

  @override
  Future<void> dispose() async {
    // No persistent resources to release.
  }
}

/// Exception thrown when the local Stable Diffusion backend returns an error.
class LocalSDException implements Exception {
  LocalSDException(this.message);

  final String message;

  @override
  String toString() => 'LocalSDException: $message';
}
