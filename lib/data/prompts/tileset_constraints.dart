/// Tileset-type-specific constraints keyed by [TilesetTypeId.name].
///
/// These describe the structural requirements for each RPG Maker MZ
/// tileset sheet type so the AI generator produces valid, game-ready sheets.
const Map<String, String> kTilesetConstraints = {
  'a1':
      'Animation autotile sheet. 16 columns x 12 rows grid (768x576 at 48px). '
      'Each animation block is 2 tiles wide x 3 tiles tall. '
      '3-frame animation loops reading left-to-right within each block. '
      'Seamless horizontal tiling for flowing water and lava scrolling. '
      'Must include waterfall-capable tiles (vertical flow frames). '
      'Frames must be visually distinct but smooth in sequence. '
      'Transparency allowed for overlay effects (e.g., fog, sparkles).',

  'a2':
      'Ground autotile sheet. 16 columns x 12 rows grid (768x576 at 48px). '
      'Each autotile block is 2 tiles wide x 3 tiles tall. '
      'Center tile plus 8 directional edge/corner variants for seamless auto-tiling. '
      'Tiles must blend naturally at borders between terrain types. '
      'Include inner-corner and outer-corner transitions. '
      'Ground should read clearly at map zoom — distinct colors per type. '
      'No transparency; fully opaque base layer tiles.',

  'a3':
      'Building autotile sheet. 16 columns x 8 rows grid (768x384 at 48px). '
      'Roof and upper-wall tiles with auto-tiling for corners and edges. '
      'Vertical stacking support — top row connects visually to wall tiles below. '
      'Include roof ridge, roof edge, roof corner, and flat roof variants. '
      'Each building style gets one 2x2 block of autotile patterns. '
      'Consistent perspective (3/4 top-down view). '
      'Walls should cast subtle downward shadow on adjacent ground.',

  'a4':
      'Wall autotile sheet. 16 columns x 15 rows grid (768x720 at 48px). '
      'Dungeon walls and tall interior/exterior wall faces. '
      'Vertical shadow gradients — darker at base, lighter at top edge. '
      'Auto-tiling edges for T-junctions, corners, and dead-ends. '
      'Each wall type gets one 2x3 block for top-face and side-face tiles. '
      'Must support both thin partition walls and thick structural walls. '
      'Ceiling/floor boundary tiles for dungeon corridor mapping.',

  'a5':
      'Normal tile sheet (no autotile). 8 columns x 16 rows grid (384x768 at 48px). '
      'Simple single-tile floor details and ground patterns. '
      'No auto-tiling logic — each tile stands alone in a strict 8x16 grid. '
      'Include floor texture variations, rugs, carpets, special ground patterns. '
      'Tiles should be individually distinct but stylistically cohesive. '
      'Fully opaque — these are base-layer tiles that sit under upper layers.',

  'b':
      'Upper-layer object sheet B. 16 columns x 16 rows grid (768x768 at 48px). '
      'Large objects, structural decorations, and building components. '
      'Top-left tile (0,0) MUST be empty/transparent — engine uses it as passthrough. '
      'Multi-tile objects span 2x2 or larger blocks arranged in the grid. '
      'All non-object pixels must be fully transparent (alpha=0). '
      'Objects should have consistent top-left lighting and drop shadows. '
      'Include: large furniture, building parts, major structural decor.',

  'c':
      'Upper-layer object sheet C. 16 columns x 16 rows grid (768x768 at 48px). '
      'Nature objects, vegetation, and organic terrain features. '
      'All non-object pixels must be fully transparent (alpha=0). '
      'Trees and tall objects should have depth-correct layering for walk-behind. '
      'Include: trees, bushes, rocks, flowers, natural formations, water features. '
      'Objects must have clean silhouettes readable against any ground tile.',

  'd':
      'Upper-layer object sheet D. 16 columns x 16 rows grid (768x768 at 48px). '
      'Interior furnishings, small decorations, and props. '
      'All non-object pixels must be fully transparent (alpha=0). '
      'Small objects (1x1 tile) and medium objects (1x2, 2x1, 2x2 tiles). '
      'Include: tables, chairs, shelves, lamps, wall hangings, containers. '
      'Consistent scale — a chair should be proportional to a table.',

  'e':
      'Upper-layer object sheet E. 16 columns x 16 rows grid (768x768 at 48px). '
      'Special items, interactive objects, and effect overlays. '
      'All non-object pixels must be fully transparent (alpha=0). '
      'Include: signs, treasure chests, switches, levers, magic circles, '
      'effect tiles (sparkles, shadows), transition objects, unique landmarks. '
      'Interactive objects should have visually distinct states where applicable.',
};
