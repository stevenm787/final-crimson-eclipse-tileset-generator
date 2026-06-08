import 'dart:typed_data';

import '../models/generation_config.dart';
import '../models/generation_result.dart';
import '../models/provider_config.dart';
import '../models/tileset_type.dart';
import 'format_validator.dart';
import 'prompt_builder.dart';
import 'provider_base.dart';
import 'usage_tracker.dart';

/// Orchestrates tileset image generation across available AI providers.
///
/// Builds the prompt, selects a provider, generates the image, tracks usage,
/// validates the result, and returns a [GenerationResult].
class GenerationService {
  /// Creates a generation service with the given [providers] and
  /// [usageTracker].
  GenerationService({
    required List<ImageGenerationProvider> providers,
    required UsageTracker usageTracker,
  })  : providers = List.unmodifiable(providers),
        _usageTracker = usageTracker;

  /// The registered providers, in priority order.
  final List<ImageGenerationProvider> providers;
  final UsageTracker _usageTracker;

  /// Maximum number of retry attempts for transient failures.
  static const int _maxRetries = 2;

  /// Generates a tileset image based on the given [config].
  ///
  /// Returns a [GenerationResult] containing the raw image bytes and metadata.
  Future<GenerationResult> generate(GenerationConfig config) async {
    // 1. Build prompt.
    final sheetType = _sheetTypeForTileset(config.tilesetType);
    final prompt = config.customPrompt ??
        PromptBuilder.buildPrompt(
          location: config.location,
          tilesetType: config.tilesetType,
          sheetType: sheetType,
        );
    final negativePrompt =
        config.negativePrompt ?? PromptBuilder.buildNegativePrompt();

    // 2. Get expected dimensions.
    final dims = config.tilesetType.getDimensions(config.tileSize);
    final width = dims.width;
    final height = dims.height;

    // 3. Select provider.
    final provider = await _selectProvider(config.provider);

    // 4. Generate image with retry logic.
    final stopwatch = Stopwatch()..start();
    Uint8List imageBytes;

    var lastError = '';
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        imageBytes = await provider.generateImage(
          prompt: prompt,
          negativePrompt: negativePrompt,
          width: width,
          height: height,
          steps: config.steps,
          guidanceScale: config.guidanceScale,
          loraModel: config.loraModel,
        );

        stopwatch.stop();

        // 5. Track usage.
        await _usageTracker.recordUsage(provider.id);

        // 6. Validate result.
        final validationErrors = FormatValidator.validate(
          imageBytes,
          config.tilesetType,
          config.tileSize,
        );

        return GenerationResult(
          imageBytes: imageBytes,
          width: width,
          height: height,
          promptUsed: prompt,
          generationTime: stopwatch.elapsed,
          validationPassed: validationErrors.isEmpty,
          validationErrors: validationErrors,
          providerUsed: provider.name,
        );
      } catch (e) {
        lastError = e.toString();
        if (attempt < _maxRetries) {
          // Brief delay before retrying.
          await Future<void>.delayed(
            Duration(seconds: 2 * (attempt + 1)),
          );
          continue;
        }
      }
    }

    stopwatch.stop();
    throw GenerationException(
      'Generation failed after ${_maxRetries + 1} attempts. '
      'Last error: $lastError',
    );
  }

  /// Selects a provider matching [preferred], or auto-selects the first
  /// available one when [preferred] is [ProviderId.auto].
  Future<ImageGenerationProvider> _selectProvider(
    ProviderId preferred,
  ) async {
    if (preferred != ProviderId.auto) {
      // Find a provider whose id matches the preferred ProviderId name.
      final match = providers.cast<ImageGenerationProvider?>().firstWhere(
            (p) => p!.id == preferred.name,
            orElse: () => null,
          );
      if (match != null) return match;
    }

    // Auto-select: return the first provider that reports availability.
    for (final provider in providers) {
      final available = await provider.checkAvailability();
      if (available) return provider;
    }

    throw GenerationException(
      'No AI providers are available. Please configure at least one provider '
      'in Settings.',
    );
  }

  /// Maps a [TilesetType] to one of the four sheet-type prompt categories.
  String _sheetTypeForTileset(TilesetType tilesetType) {
    switch (tilesetType.id) {
      case TilesetTypeId.a1:
      case TilesetTypeId.a2:
      case TilesetTypeId.a5:
        return 'terrain';
      case TilesetTypeId.a3:
      case TilesetTypeId.a4:
        return 'walls';
      case TilesetTypeId.b:
      case TilesetTypeId.c:
      case TilesetTypeId.d:
        return 'decor';
      case TilesetTypeId.e:
        return 'special';
    }
  }
}

/// Exception thrown when image generation fails.
class GenerationException implements Exception {
  GenerationException(this.message);

  final String message;

  @override
  String toString() => 'GenerationException: $message';
}
