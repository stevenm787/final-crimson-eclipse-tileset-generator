import '../models/location.dart';

/// All 26 locations in the Crimson Eclipse world.
const List<Location> kLocations = [
  // ── Hub Cities (3) ──────────────────────────────────────────────────
  Location(
    id: 'hub_vel_sahrad',
    name: 'Vel Sahrad',
    category: 'Hub Cities',
    culturalInspiration: 'London',
    visualMotifs: 'Victorian Gothic/Urban Decay',
  ),
  Location(
    id: 'hub_val_duivra',
    name: 'Val Duivra',
    category: 'Hub Cities',
    culturalInspiration: 'France',
    visualMotifs: 'Gothic Cathedral/Chess Motifs',
  ),
  Location(
    id: 'hub_skythenos',
    name: 'Skythenos Cloud City',
    category: 'Hub Cities',
    culturalInspiration: 'Greece',
    visualMotifs: 'Ethereal Heights/Classical Ruins',
  ),

  // ── Font Dungeons (5) ───────────────────────────────────────────────
  Location(
    id: 'font_garn_caladrun',
    name: 'Garn Caladrun',
    category: 'Font Dungeons',
    element: 'Earth',
    visualMotifs: 'Carved stone/crystal formations/Aztec glyphs',
  ),
  Location(
    id: 'font_khenenu_deep',
    name: 'Khenenu Deep',
    category: 'Font Dungeons',
    element: 'Water',
    visualMotifs: 'Flooded temples/bioluminescent flora/Egyptian',
  ),
  Location(
    id: 'font_skyvaldr_cliffs',
    name: 'Skyvaldr Cliffs',
    category: 'Font Dungeons',
    element: 'Air',
    visualMotifs: 'Floating platforms/wind-carved stone/Greek',
  ),
  Location(
    id: 'font_volkheth_sarmaar',
    name: 'Volkheth Sarmaar',
    category: 'Font Dungeons',
    element: 'Fire',
    visualMotifs: 'Volcanic stone/lava rivers/Persian',
  ),
  Location(
    id: 'font_sanctum_hollow',
    name: 'Sanctum of Hollow Winds',
    category: 'Font Dungeons',
    element: 'Harmony',
    visualMotifs: 'Gothic cathedral/elemental fusion',
  ),

  // ── Sin Worlds (7) ─────────────────────────────────────────────────
  Location(
    id: 'sin_vault_gold',
    name: 'Vault of Hollow Gold',
    category: 'Sin Worlds',
    sin: 'Greed',
    chakra: 'Root',
    visualMotifs: 'Endless treasure/gold-plated/bank vault',
  ),
  Location(
    id: 'sin_crimson_mirage',
    name: 'Crimson Mirage Temple',
    category: 'Sin Worlds',
    sin: 'Lust',
    chakra: 'Sacral',
    visualMotifs: 'Veiled chambers/mirrors/rose gardens',
  ),
  Location(
    id: 'sin_maw_bloom',
    name: 'Maw of Endless Bloom',
    category: 'Sin Worlds',
    sin: 'Gluttony',
    chakra: 'Solar Plexus',
    visualMotifs: 'Overgrown gardens/rotting feasts/parasitic plants',
  ),
  Location(
    id: 'sin_garden_withered',
    name: 'Garden of Withered Light',
    category: 'Sin Worlds',
    sin: 'Sloth',
    chakra: 'Heart',
    visualMotifs: 'Faded gardens/comfortable decay/eternal twilight',
  ),
  Location(
    id: 'sin_fortress_voices',
    name: 'Fortress of Broken Voices',
    category: 'Sin Worlds',
    sin: 'Wrath',
    chakra: 'Throat',
    visualMotifs: 'Shattered architecture/volcanic cracks/war memorials',
  ),
  Location(
    id: 'sin_mirror_sanctum',
    name: 'Mirror Sanctum',
    category: 'Sin Worlds',
    sin: 'Envy',
    chakra: 'Third Eye',
    visualMotifs: 'Infinite mirrors/duplicated architecture/green tints',
  ),
  Location(
    id: 'sin_ecliptic_throne',
    name: 'The Ecliptic Throne',
    category: 'Sin Worlds',
    sin: 'Pride',
    chakra: 'Crown',
    visualMotifs: 'Towering spires/god-like statuary/solar imagery',
  ),

  // ── Revelation (2) ─────────────────────────────────────────────────
  Location(
    id: 'rev_lachrymal_gate',
    name: 'The Lachrymal Gate',
    category: 'Revelation',
    theme: 'Eighth Chakra',
  ),
  Location(
    id: 'rev_vordr_restoration',
    name: 'The Vordr Restoration',
    category: 'Revelation',
    theme: 'Barrier Healing',
  ),

  // ── Overworlds (4) ─────────────────────────────────────────────────
  Location(
    id: 'region_xochzan',
    name: "Xoch'Zan Jungle",
    category: 'Overworlds',
    culturalInspiration: 'Aztec',
  ),
  Location(
    id: 'region_pelmara',
    name: 'Pelmara Coast',
    category: 'Overworlds',
    culturalInspiration: 'Egyptian',
  ),
  Location(
    id: 'region_skythenos',
    name: 'Skythenos Region',
    category: 'Overworlds',
    culturalInspiration: 'Greek',
  ),
  Location(
    id: 'region_imenthi',
    name: 'Imenthi Reach',
    category: 'Overworlds',
    culturalInspiration: 'Persian',
  ),

  // ── Special (2) ────────────────────────────────────────────────────
  Location(
    id: 'special_chess_demon',
    name: 'Chess Demon Belcour',
    category: 'Special',
  ),
  Location(
    id: 'special_dreamwalking',
    name: 'Dreamwalking Spaces',
    category: 'Special',
  ),

  // ── General (2) ────────────────────────────────────────────────────
  Location(
    id: 'overworld_general',
    name: 'Overworld General',
    category: 'General',
  ),
  Location(
    id: 'overworld_space',
    name: 'Overworld Outer Space',
    category: 'General',
  ),
];

/// Locations grouped by their [Location.category].
Map<String, List<Location>> get locationsByCategory {
  final Map<String, List<Location>> grouped = {};
  for (final location in kLocations) {
    grouped.putIfAbsent(location.category, () => []).add(location);
  }
  return grouped;
}
