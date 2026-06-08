import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../provider_base.dart';

/// Image generation provider backed by the HuggingFace Inference API.
///
/// Sends text-to-image requests to a hosted Stable Diffusion model and
/// returns the raw PNG bytes from the response.
class HuggingFaceProvider implements ImageGenerationProvider {
  /// Creates a provider that authenticates with [apiToken].
  ///
  /// [modelId] defaults to Stable Diffusion XL Base 1.0.
  HuggingFaceProvider({
    required this.apiToken,
    this.modelId = 'stabilityai/stable-diffusion-xl-base-1.0',
  });

  /// Bearer token for the HuggingFace API.
  final String apiToken;

  /// Fully-qualified model identifier on HuggingFace Hub.
  final String modelId;

  /// Maximum number of retries when the model is still loading (503).
  static const int _maxRetries = 3;

  /// Delay between retries when the model is loading.
  static const Duration _retryDelay = Duration(seconds: 20);

  @override
  String get name => 'HuggingFace';

  @override
  String get id => 'huggingFace';

  String get _baseUrl =>
      'https://api-inference.huggingface.co/models/$modelId';

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      };

  @override
  Future<bool> checkAvailability() async {
    try {
      final response = await http.head(
        Uri.parse(_baseUrl),
        headers: {'Authorization': 'Bearer $apiToken'},
      );
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
    final effectivePrompt =
        loraModel != null ? '<lora:$loraModel> $prompt' : prompt;

    final body = jsonEncode({
      'inputs': effectivePrompt,
      'parameters': {
        if (negativePrompt != null) 'negative_prompt': negativePrompt,
        'width': width,
        'height': height,
        'num_inference_steps': steps,
        'guidance_scale': guidanceScale,
      },
    });

    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }

      if (response.statusCode == 503 && attempt < _maxRetries) {
        // Model is loading; wait and retry.
        await Future<void>.delayed(_retryDelay);
        continue;
      }

      final errorMessage = _parseError(response);
      throw HuggingFaceException(
        'HuggingFace API error (${response.statusCode}): $errorMessage',
        statusCode: response.statusCode,
      );
    }

    throw HuggingFaceException(
      'Model $modelId did not become available after $_maxRetries retries.',
      statusCode: 503,
    );
  }

  String _parseError(http.Response response) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['error']?.toString() ?? response.body;
    } catch (_) {
      return response.body;
    }
  }

  @override
  Future<void> dispose() async {
    // No persistent resources to release.
  }
}

/// Exception thrown when the HuggingFace API returns an error.
class HuggingFaceException implements Exception {
  HuggingFaceException(this.message, {required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => 'HuggingFaceException: $message';
}
