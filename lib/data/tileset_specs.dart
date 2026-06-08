import '../models/tileset_type.dart';

/// All nine RPG Maker MZ tileset sheet types.
const List<TilesetType> kTilesetTypes = [
  TilesetType(
    id: TilesetTypeId.a1,
    name: 'A1 - Animations',
    category: 'Layer A',
    purpose: 'Animations (water, lava, effects)',
  ),
  TilesetType(
    id: TilesetTypeId.a2,
    name: 'A2 - Ground',
    category: 'Layer A',
    purpose: 'Ground autotiles (grass, dirt, paths)',
  ),
  TilesetType(
    id: TilesetTypeId.a3,
    name: 'A3 - Buildings',
    category: 'Layer A',
    purpose: 'Building autotiles (roofs, exterior walls)',
  ),
  TilesetType(
    id: TilesetTypeId.a4,
    name: 'A4 - Walls',
    category: 'Layer A',
    purpose: 'Wall autotiles (dungeon walls, interior walls)',
  ),
  TilesetType(
    id: TilesetTypeId.a5,
    name: 'A5 - Normal',
    category: 'Layer A',
    purpose: 'Normal tiles (floor details, simple terrain)',
  ),
  TilesetType(
    id: TilesetTypeId.b,
    name: 'B - Objects',
    category: 'Layer B-E',
    purpose: 'Upper-layer objects and large decorations',
  ),
  TilesetType(
    id: TilesetTypeId.c,
    name: 'C - Objects',
    category: 'Layer B-E',
    purpose: 'Upper-layer objects and props',
  ),
  TilesetType(
    id: TilesetTypeId.d,
    name: 'D - Objects',
    category: 'Layer B-E',
    purpose: 'Upper-layer objects and decorations',
  ),
  TilesetType(
    id: TilesetTypeId.e,
    name: 'E - Objects',
    category: 'Layer B-E',
    purpose: 'Upper-layer objects and special elements',
  ),
];

/// Supported tile sizes in pixels (descending order).
const List<int> kTileSizes = [48, 32, 24, 16];
