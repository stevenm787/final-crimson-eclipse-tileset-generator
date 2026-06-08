import '../data/prompts/base_style.dart';
import '../data/prompts/location_prompts.dart';
import '../data/prompts/tileset_constraints.dart';
import '../models/location.dart';
import '../models/tileset_type.dart';

/// Assembles generation prompts from location data, tileset constraints,
/// and the global style foundation.
class PromptBuilder {
  PromptBuilder._();

  /// Builds a complete generation prompt for the given parameters.
  ///
  /// [location] is the game location to generate tiles for.
  /// [tilesetType] is the RPG Maker MZ sheet type (A1-E).
  /// [sheetType] maps to the prompt category:
  ///   - `'terrain'` for T sheets (ground/terrain tiles)
  ///   - `'walls'` for W sheets (wall/barrier tiles)
  ///   - `'decor'` for D sheets (decoration/furniture tiles)
  ///   - `'special'` for S sheets (special/effect tiles)
  static String buildPrompt({
    required Location location,
    required TilesetType tilesetType,
    required String sheetType,
  }) {
    final buffer = StringBuffer();

    // 1. Global header.
    buffer.writeln(kGlobalHeader);
    buffer.writeln();

    // 2. Location-specific prompt.
    final locationPrompts = kLocationPrompts[location.id];
    if (locationPrompts != null) {
      final sheetPrompt = locationPrompts[sheetType];
      if (sheetPrompt != null) {
        buffer.writeln('Location: ${location.name}');
        buffer.writeln(sheetPrompt);
        buffer.writeln();
      }
    }

    // Add cultural/element/visual context from the location model.
    if (location.culturalInspiration != null) {
      buffer.writeln('Cultural style: ${location.culturalInspiration}');
    }
    if (location.element != null) {
      buffer.writeln('Element: ${location.element}');
    }
    if (location.sin != null) {
      buffer.writeln('Sin theme: ${location.sin}');
    }
    if (location.visualMotifs != null) {
      buffer.writeln('Visual motifs: ${location.visualMotifs}');
    }
    buffer.writeln();

    // 3. Tileset-type structural constraints.
    final constraints = kTilesetConstraints[tilesetType.id.name];
    if (constraints != null) {
      buffer.writeln('Tileset constraints: $constraints');
      buffer.writeln();
    }

    // 4. Style foundation.
    buffer.writeln(kStyleFoundation);

    return buffer.toString().trimRight();
  }

  /// Returns the default negative prompt used for all generations.
  static String buildNegativePrompt() => kNegativePrompt;
}
