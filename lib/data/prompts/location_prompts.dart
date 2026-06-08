/// Location-specific prompts keyed by location ID and sheet type.
///
/// Structure: `kLocationPrompts[locationId][sheetType]`
/// where sheetType is one of: 'terrain', 'walls', 'decor', 'special'
const Map<String, Map<String, String>> kLocationPrompts = {
  // ── Hub Cities ───────────────────────────────────────────────────────

  'hub_vel_sahrad': {
    'terrain':
        'Murky river water, oily canal water with gaslamp glows. '
        'Wet cobblestones, brick pavements, dock planks, muddy alleys, '
        'tram tracks, manhole covers.',
    'walls':
        'Tall brick/brownstone townhouses, slate roofs, Tudor/Victorian facades, '
        'factory facades with smokestacks, industrial pipe-walls, stone gatehouses.',
    'decor':
        'Gas streetlamps, pub signs, benches, crates, barrels, market stalls, '
        'dock bollards, rope coils, pigeons, trash bags.',
    'special':
        "Chor'Kaht shrines, echo-crystal pedestals, resonance pylons, "
        'Guild signage, broken portals, large monuments.',
  },

  'hub_val_duivra': {
    'terrain':
        'Gentle rivers, village canals. Cobblestone streets, grass fields, '
        'vineyard rows, farm soil.',
    'walls':
        'Two-story houses with shutters, vineyard barns, manor fronts, '
        'terrace retaining walls.',
    'decor':
        'Cafe tables, flower boxes, market carts, grape vine rows, '
        'hay bales, plows.',
    'special':
        'Chess piece statues, bell towers, fountain landmarks.',
  },

  'hub_skythenos': {
    'terrain':
        'Sky fountains, thin streams falling into clouds. Marble plaza tiles, '
        'cloud-bordered platforms, sky bridges.',
    'walls':
        'Columned marble temples, palatial facades with balconies, '
        'sky-cliffs dropping into void, friezes.',
    'decor':
        'Benches, sky-tree planters, banners, winged guardian statues, '
        'sacred braziers.',
    'special':
        'Central sky spire fragments, massive entrance gates, '
        'floating ring-structures.',
  },

  // ── Font Dungeons ────────────────────────────────────────────────────

  'font_garn_caladrun': {
    'terrain':
        'Subterranean pools, glowing mineral water trickles. Cracked earth, '
        'fossil soil, hexagonal stone plates, crystal-veined rock.',
    'walls':
        'Rock shrines, pillared earth temples, rough cave walls with ore, '
        'chiseled block walls with runes.',
    'decor':
        'Stalagmites, stalactites, boulders, crystal spikes, wooden support beams, '
        'movable stone blocks, rotating rune pillars.',
    'special':
        'Giant sealed earth sigils, earth golem statues, floating rock fragments.',
  },

  'font_khenenu_deep': {
    'terrain':
        'Abyssal flows, glowing trench water, algae-slick stone, '
        'flooded mosaics, coral-covered tiles.',
    'walls':
        'Sunken temple facades, seaweed-draped pillars, crumbling coral walls, '
        'barnacled columns.',
    'decor':
        'Kelp, coral fans, anemones, sunken chests, ancient tablets, '
        'barnacled braziers.',
    'special':
        'Giant chained idols, abyssal chasm gates, monolith circles.',
  },

  'font_skyvaldr_cliffs': {
    'terrain':
        'Narrow cliffside waterfalls, dripping streams. Cracked stone paths, '
        'rope-bridge floors, runic platforms.',
    'walls':
        'Stone outpost facades, wind shrines carved into rock, '
        'sheer rock faces with overhangs.',
    'decor':
        'Rope bridge rails, support posts, windmills, spinning fans, '
        'wind glyph pillars.',
    'special':
        'Giant wind altar multi-tiles, broken sky elevator parts.',
  },

  'font_volkheth_sarmaar': {
    'terrain':
        'Slow lava rivers, bubbling lava pools. Black basalt plates, '
        'charred stone with ash, metal grates over lava.',
    'walls':
        'Iron-braced fortress facades, fire temple fronts, '
        'jagged basalt walls with lava veins.',
    'decor':
        'Braziers, fire jets, lava spouts, hanging chains, hooks, cages, '
        'spiked fences.',
    'special':
        'Giant central fire altars, molten pillars, ember swirl magic.',
  },

  'font_sanctum_hollow': {
    'terrain':
        'Reflective ritual pools, swirling sacred water. Polished stone tiles, '
        'glass-like floors, choir platforms.',
    'walls':
        'Organ fronts, altar facades, stained-glass windows, vaulted arches.',
    'decor':
        'Lecterns, candle stands, music stands, hanging elemental banners, '
        'wind chimes.',
    'special':
        'Central ritual dais, giant wind organ pipes.',
  },

  // ── Sin Worlds ───────────────────────────────────────────────────────

  'sin_vault_gold': {
    'terrain':
        'Molten gold pools, toxic sludge variants. Gold-inlaid stone, '
        'coin-strewn floors, heavy iron grates.',
    'walls':
        'Massive vault doors, safe deposit walls, gold-paneled structural walls, '
        'gold vein walls.',
    'decor':
        'Mounds of gold coins, treasure chests, gold bars, safes, '
        'lockboxes, tripwire posts.',
    'special':
        'Giant central vault mechanisms, monumental greed statues.',
  },

  'sin_crimson_mirage': {
    'terrain':
        'Rippling indoor pools with rose reflections, mirage patterns. '
        'Silky carpets, mirror-floor tiles.',
    'walls':
        'Curved walls with alcoves, lattice windows, archways with bead curtains, '
        'mirror-panel walls.',
    'decor':
        'Cushions, divans, draped fabrics, canopies, standing mirrors, '
        'illusory silhouettes.',
    'special':
        'Grand central ritual pools, massive veiled statues.',
  },

  'sin_maw_bloom': {
    'terrain':
        'Thick golden honey liquid, plant sap pools, digestion pits. '
        'Fleshy plant carpets, root mats.',
    'walls':
        'Stone dining halls with vines, root-wrapped archways, '
        'fleshy plant tunnel walls.',
    'decor':
        'Overloaded feast tables, carnivorous plants, spore clouds, '
        'rotten food heaps.',
    'special':
        'Enormous plant maws, giant feast tables.',
  },

  'sin_garden_withered': {
    'terrain':
        'Stagnant algae-choked ponds. Cracked flagstones, faded grass, '
        'bare dirt, sunken benches.',
    'walls':
        'Crumbling gazebos, broken glasshouse fronts, '
        'old stone walls with dead vines.',
    'decor':
        'Dead trees, wilted bushes, broken lanterns, cobweb overlays, '
        'dust clouds.',
    'special':
        'Large withered tree centerpiece, heart-beacon altars.',
  },

  'sin_fortress_voices': {
    'terrain':
        'Resonating fluid pools. Cracked black stone floors, '
        'resonance circle patterns, sound-inscribed tiles.',
    'walls':
        'Tower facades with horn protrusions, bastion fronts, '
        'walls with speaker-runes.',
    'decor':
        'Hanging bells, gongs, drums, resonance pillars, PA-horn structures.',
    'special':
        'Massive broken bell pieces, central echo chambers.',
  },

  'sin_mirror_sanctum': {
    'terrain':
        'Perfectly reflective pools. Polished mirror tiles, prism crystal tiles, '
        'eye-motif mosaics.',
    'walls':
        'Crystal-fronted halls, faceted prism walls, '
        'walls with inset watching eyes.',
    'decor':
        'Standing mirrors, mirror shards, silhouettes of clones, eye sigils.',
    'special':
        'Giant central mirrors, mirror maze overlays.',
  },

  'sin_ecliptic_throne': {
    'terrain':
        'Starfield liquid with constellations. Astral floor patterns, '
        'celestial marble, void bridges.',
    'walls':
        'Monolithic throne facades, crown-motif pillars, '
        'cosmic walls with galaxy swirls.',
    'decor':
        'Floating star fragments, ethereal banners, celestial spheres.',
    'special':
        'The Ecliptic Throne itself, cosmic gateway portals.',
  },

  // ── Revelation ───────────────────────────────────────────────────────

  'rev_lachrymal_gate': {
    'terrain':
        'Luminous tear-drop pools, shimmering ethereal water. '
        'Translucent crystal tiles, radiant white stone, chakra-symbol floors.',
    'walls':
        'Towering gate pillars of fused light, crystallized emotion walls, '
        'transcendent archways with halo motifs.',
    'decor':
        'Floating tear-drop crystals, prayer stones, ascending light pillars, '
        'soul lanterns, eighth-chakra sigils.',
    'special':
        'The Lachrymal Gate itself, massive transcendence portal, '
        'chakra alignment circles.',
  },

  'rev_vordr_restoration': {
    'terrain':
        'Healing spring water with golden motes, mending light pools. '
        'Restored stone tiles, barrier-rune floors, renewal moss patches.',
    'walls':
        'Barrier-woven walls with protective sigils, restored ancient facades, '
        'living-light barriers, Vordr guardian reliefs.',
    'decor':
        'Restoration beacons, barrier crystals, mending tools, '
        'guardian totems, protective ward stones.',
    'special':
        'Grand barrier restoration altar, Vordr guardian manifestation circle, '
        'world-healing nexus.',
  },

  // ── Overworlds ───────────────────────────────────────────────────────

  'region_xochzan': {
    'terrain':
        'Shallow jungle streams, dark foliage pools. Packed earth, '
        'root-tangled soil, mossy paths, temple floor tiles, '
        'engraved glyph panels.',
    'walls':
        'Stepped stone temples, overgrown shrines, jungle outpost huts, '
        'carved stone walls with faces, vine-draped cliffs.',
    'decor':
        'Modular jungle trees, ferns, bushes, hanging vines, stone totems, '
        'idol statues, green-fire braziers, bone piles.',
    'special':
        'Massive broken idol head/hands, sealed vine-knot gates, '
        'ritual story altars.',
  },

  'region_pelmara': {
    'terrain':
        'Open sea water, shallow surf, tidepool rocks. Dry/wet sand, '
        'pebbles, harbor stone quays, dune grass.',
    'walls':
        'Fisher cottages, boathouses, lighthouse facades, layered sea cliffs, '
        'mossy seawalls.',
    'decor':
        'Boats, rowboats, anchors, buoys, fishing nets, crates of fish, '
        'palm trees, seaside market stalls.',
    'special':
        'Broken sea-statues, ceremonial dock altars, water sigil circles.',
  },

  'region_skythenos': {
    'terrain':
        'Mountain streams, cliff-edge waterfalls. Rocky highland paths, '
        'marble road tiles, cloud-level grass, olive grove soil.',
    'walls':
        'White marble temple ruins, columned porticos, hillside terraces, '
        'ancient amphitheater walls, stone aqueducts.',
    'decor':
        'Olive trees, grapevine trellises, broken columns, amphora pots, '
        'bronze shield displays, laurel wreaths.',
    'special':
        'Oracle shrine platforms, mythic beast statues, '
        'celestial observatory ruins.',
  },

  'region_imenthi': {
    'terrain':
        'Oasis pools, irrigation channels. Smooth sand, rippled dunes, '
        'caravan tracks, baked riverbeds.',
    'walls':
        'Flat-roofed domed houses, temple fronts with obelisks, '
        'sandstone canyon walls, tomb reliefs.',
    'decor':
        'Tents, canopies, market stalls, clay jars, palm trees, '
        'cacti, obelisks.',
    'special':
        'Massive half-buried statue pieces, monumental gates.',
  },

  // ── Special ──────────────────────────────────────────────────────────

  'special_chess_demon': {
    'terrain':
        'Checkered marble floors in black and white, glowing grid lines, '
        'polished obsidian tiles, chess-notation inscribed stone.',
    'walls':
        'Giant chess piece facades, game-board border walls, '
        'strategic diagram panels, opponent gallery walls.',
    'decor':
        'Chess piece statues (pawn, rook, bishop, knight, queen, king), '
        'game clocks, strategy scrolls, captured piece piles.',
    'special':
        'Belcour demon chess throne, transforming board tiles, '
        'demonic chess piece boss arenas.',
  },

  'special_dreamwalking': {
    'terrain':
        'Liquid starlight pools, shifting dream-fog floors, '
        'translucent memory tiles, impossible geometry paths.',
    'walls':
        'Dissolving reality walls, memory fragment barriers, '
        'dream-logic architecture, Escher-like impossible walls.',
    'decor':
        'Floating memory orbs, dream catchers, surreal clocks, '
        'fragmented NPC silhouettes, thought bubbles.',
    'special':
        'Dream nexus portals, nightmare corruption zones, '
        'lucid dream anchors, memory reconstruction altars.',
  },

  // ── General ──────────────────────────────────────────────────────────

  'overworld_general': {
    'terrain':
        'Grass fields, dirt roads, forest clearings, river crossings, '
        'mountain paths, bridge surfaces, village squares.',
    'walls':
        'Generic town buildings, wooden fences, stone walls, hedgerows, '
        'cliff faces, cave entrances, castle battlements.',
    'decor':
        'Trees (oak, pine, willow), bushes, flowers, signposts, wells, '
        'wagons, hay bales, barrels, crates, campfires.',
    'special':
        'World map landmarks, dungeon entrance markers, '
        'town gate transitions, fast-travel waypoints.',
  },

  'overworld_space': {
    'terrain':
        'Nebula-lit void platforms, asteroid surfaces, star-crystal paths, '
        'cosmic dust trails, zero-gravity walkways.',
    'walls':
        'Space station hull walls, asteroid cliff faces, energy barriers, '
        'cosmic rift edges, orbital platform railings.',
    'decor':
        'Floating debris, satellite dishes, star crystals, space flora, '
        'holographic displays, energy conduits.',
    'special':
        'Black hole event horizons, cosmic gates, '
        'stellar forge platforms, void beacons.',
  },
};
