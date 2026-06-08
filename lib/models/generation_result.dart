import 'dart:typed_data';

/// The result of a tileset generation request.
class GenerationResult {
  final Uint8List imageBytes;
  final int width;
  final int height;
  final String promptUsed;
  final Duration generationTime;
  final bool validationPassed;
  final List<String> validationErrors;
  final String providerUsed;

  const GenerationResult({
    required this.imageBytes,
    required this.width,
    required this.height,
    required this.promptUsed,
    required this.generationTime,
    required this.validationPassed,
    this.validationErrors = const [],
    required this.providerUsed,
  });

  @override
  String toString() =>
      'GenerationResult(${width}x$height, '
      'valid: $validationPassed, '
      'provider: $providerUsed, '
      'time: ${generationTime.inMilliseconds}ms)';
}
