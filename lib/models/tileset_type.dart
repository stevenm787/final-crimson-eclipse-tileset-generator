/// Identifiers for the RPG Maker MZ tileset sheet types.
enum TilesetTypeId {
  a1,
  a2,
  a3,
  a4,
  a5,
  b,
  c,
  d,
  e,
}

/// Describes a tileset sheet type and its dimensional requirements.
class TilesetType {
  final TilesetTypeId id;
  final String name;
  final String category;
  final String purpose;

  const TilesetType({
    required this.id,
    required this.name,
    required this.category,
    required this.purpose,
  });

  /// Returns the pixel dimensions and tile grid counts for a given [tileSize].
  ///
  /// The base dimensions are defined for 48px tiles and scale proportionally
  /// for 32, 24, and 16 px tiles.
  ({int width, int height, int cols, int rows}) getDimensions(int tileSize) {
    final double scale = tileSize / 48.0;

    // Base dimensions at 48px tile size.
    final int baseWidth;
    final int baseHeight;
    final int cols;
    final int rows;

    switch (id) {
      case TilesetTypeId.a1:
        baseWidth = 768;
        baseHeight = 576;
        cols = 16;
        rows = 12;
      case TilesetTypeId.a2:
        baseWidth = 768;
        baseHeight = 576;
        cols = 16;
        rows = 12;
      case TilesetTypeId.a3:
        baseWidth = 768;
        baseHeight = 384;
        cols = 16;
        rows = 8;
      case TilesetTypeId.a4:
        baseWidth = 768;
        baseHeight = 720;
        cols = 16;
        rows = 15;
      case TilesetTypeId.a5:
        baseWidth = 384;
        baseHeight = 768;
        cols = 8;
        rows = 16;
      case TilesetTypeId.b:
      case TilesetTypeId.c:
      case TilesetTypeId.d:
      case TilesetTypeId.e:
        baseWidth = 768;
        baseHeight = 768;
        cols = 16;
        rows = 16;
    }

    return (
      width: (baseWidth * scale).round(),
      height: (baseHeight * scale).round(),
      cols: cols,
      rows: rows,
    );
  }

  @override
  String toString() => 'TilesetType($name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TilesetType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
