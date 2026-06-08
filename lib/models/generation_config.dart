import 'location.dart';
import 'tileset_type.dart';
import 'provider_config.dart';

/// Holds all parameters needed to request an AI-generated tileset sheet.
class GenerationConfig {
  final Location location;
  final TilesetType tilesetType;
  final int tileSize;
  final ProviderId provider;
  final String? customPrompt;
  final String? negativePrompt;
  final int steps;
  final double guidanceScale;
  final String? loraModel;

  const GenerationConfig({
    required this.location,
    required this.tilesetType,
    this.tileSize = 48,
    required this.provider,
    this.customPrompt,
    this.negativePrompt,
    this.steps = 30,
    this.guidanceScale = 7.5,
    this.loraModel,
  });

  @override
  String toString() =>
      'GenerationConfig(${location.id}, ${tilesetType.name}, ${tileSize}px)';
}
