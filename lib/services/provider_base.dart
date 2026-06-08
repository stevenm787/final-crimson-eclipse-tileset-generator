import 'dart:typed_data';

/// Abstract interface for AI image-generation providers.
///
/// Each concrete provider (HuggingFace, Google Gemini, Local SD) implements
/// this contract so the generation service can treat them uniformly.
abstract class ImageGenerationProvider {
  /// Human-readable name for this provider.
  String get name;

  /// Unique identifier for this provider.
  String get id;

  /// Tests whether the provider endpoint is reachable and ready.
  ///
  /// Returns `true` if the provider can accept generation requests.
  Future<bool> checkAvailability();

  /// Generates an image from the given [prompt] and returns PNG bytes.
  ///
  /// Parameters:
  /// - [prompt]: The positive text prompt describing the desired image.
  /// - [negativePrompt]: Optional negative prompt to steer away from.
  /// - [width]: Output image width in pixels.
  /// - [height]: Output image height in pixels.
  /// - [steps]: Number of inference steps (default 30).
  /// - [guidanceScale]: CFG scale controlling prompt adherence (default 7.5).
  /// - [loraModel]: Optional LoRA model identifier to apply.
  Future<Uint8List> generateImage({
    required String prompt,
    String? negativePrompt,
    required int width,
    required int height,
    int steps = 30,
    double guidanceScale = 7.5,
    String? loraModel,
  });

  /// Releases any resources held by this provider.
  Future<void> dispose();
}
