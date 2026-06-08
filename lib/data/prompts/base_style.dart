/// Global header prepended to every generation prompt.
const String kGlobalHeader =
    'RPG Architect tileset, pixel art, 48x48 tile grid, crisp clean details. '
    'JRPG gothic dark sci-fi fantasy style, seamless tile edges, game-ready. '
    'No UI, no labels, no logos, no extra borders. '
    'Canvas size: multiples of 48. '
    'Transparent background for decor/special sheets.';

/// Core visual style foundation for the Crimson Eclipse universe.
const String kStyleFoundation = '''
Gothic dark fantasy aesthetic with oppressive atmosphere and muted grandeur.
Sci-fi undertones with ancient technology — arcane circuitry, echo-crystal terminals, resonance pylons.
Top-down JRPG perspective (3/4 view implied depth) for all tileset sheets.
Pixel art with clean edges and limited anti-aliasing for crisp readability.
16-32 color palette per tileset to maintain visual coherence.
High contrast with readable silhouettes so every tile is identifiable at a glance.
Consistent light source from top-left by default; warm key, cool fill.
Atmospheric depth conveyed through color temperature shifts (warm foreground, cool background).
Organic meets mechanical visual tension — living stone, breathing metal, grown architecture.''';

/// Default negative prompt appended to every generation request.
const String kNegativePrompt =
    'blurry, low quality, watermark, text, UI elements, labels, logos, '
    'borders, 3D rendering, photorealistic, smooth gradients';
