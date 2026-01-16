# The Crimson Eclipse: Tileset Generator

## Electron Application Development Plan

**Version:** 1.0  
**Target Engine:** RPG Maker MZ  
**Visual Style:** Gothic / Sci-Fi / Dark Fantasy / Top-Down JRPG / Pixel Art

---

## 1. Executive Summary

This document outlines the complete development plan for an Electron-based tileset generation application designed specifically for *The Crimson Eclipse*. The application will generate properly-formatted tileset assets that strictly adhere to RPG Maker MZ specifications while maintaining the game's distinctive Gothic/Sci-Fi/Dark Fantasy aesthetic.

The generator will leverage AI image generation APIs to produce pixel art tilesets based on location-specific prompts, automatically formatting outputs to match RPG Maker MZ's complex tileset requirements.

---

## 2. Location Registry

All locations are extracted from the Crimson Eclipse GDD and supporting framework documents.

### 2.1 Hub Cities

| Location ID | Name | Cultural Inspiration | Primary Theme |
|-------------|------|---------------------|---------------|
| `hub_vel_sahrad` | Vel Sahrad | London | Victorian Gothic, Urban Decay |
| `hub_val_duivra` | Val Duivra | France | Gothic Cathedral, Chess Motifs |
| `hub_skythenos` | Skýthenos Cloud City | Greece | Ethereal Heights, Classical Ruins |

### 2.2 Act I: Font Dungeons (Elemental)

| Location ID | Name | Region | Element | Aspect | Visual Motifs |
|-------------|------|--------|---------|--------|---------------|
| `font_garn_caladrun` | Garn Caladrûn | Xoch'Zan Jungle | Earth | Brígaeth | Carved stone, root systems, crystal formations, Aztec-inspired glyphs |
| `font_khenenu_deep` | Khenenu Deep | Pelmara Coast | Water | Nebt'Aset | Flooded temples, bioluminescent flora, Egyptian architecture, coral |
| `font_skyvaldr_cliffs` | Skývaldr Cliffs | Skýthenos | Air | Yllra | Floating platforms, wind-carved stone, Greek temple elements, clouds |
| `font_volkheth_sarmaar` | Volkheth Sármaar | Imenthi Reach | Fire | Sekhetu | Volcanic stone, lava rivers, brass mechanisms, Persian/Mesopotamian influence |
| `font_sanctum_hollow` | Sanctum of Hollow Winds | Val Duivra | Harmony | All Four | Gothic cathedral, elemental fusion, stained glass, balanced energy |

### 2.3 Act II: Sin World Dungeons

| Location ID | Name | Sin | Chakra | Visual Motifs |
|-------------|------|-----|--------|---------------|
| `sin_vault_gold` | Vault of Hollow Gold | Greed | Root | Endless treasure, gold-plated surfaces, bank vault aesthetics, dragon hoards |
| `sin_crimson_mirage` | Crimson Mirage Temple | Lust | Sacral | Veiled chambers, mirrors, rose gardens, seductive architecture |
| `sin_maw_bloom` | Maw of Endless Bloom | Gluttony | Solar Plexus | Overgrown gardens, rotting feasts, parasitic plants, digestive imagery |
| `sin_garden_withered` | Garden of Withered Light | Sloth | Heart | Faded gardens, comfortable decay, eternal twilight, time-frozen scenes |
| `sin_fortress_voices` | Fortress of Broken Voices | Wrath | Throat | Shattered architecture, volcanic cracks, war memorials, echoing halls |
| `sin_mirror_sanctum` | Mirror Sanctum | Envy | Third Eye | Infinite mirrors, duplicated architecture, green tints, identity confusion |
| `sin_ecliptic_throne` | The Ecliptic Throne | Pride | Crown | Towering spires, god-like statuary, solar imagery, isolating heights |

### 2.4 Act III: Revelation Dungeons

| Location ID | Name | Theme | Visual Motifs |
|-------------|------|-------|---------------|
| `rev_lachrymal_gate` | The Lachrymal Gate | Eighth Chakra | Ouroboric loops, chakra-themed segments, metaphysical architecture |
| `rev_vordr_restoration` | The Vörðr Restoration | Barrier Healing | Central lattice, elemental chambers, synthesis chambers |

### 2.5 Regional Overworlds

| Location ID | Name | Cultural Inspiration | Visual Motifs |
|-------------|------|---------------------|---------------|
| `region_xochzan` | Xoch'Zan Jungle | Aztec/Mesoamerican | Dense jungle, ancient ruins, stone pyramids, carved reliefs |
| `region_pelmara` | Pelmara Coast | Egyptian/Mediterranean | Coastal cliffs, tidal pools, ancient harbors, lighthouse ruins |
| `region_skythenos` | Skýthenos Region | Greek | Mountain peaks, cloud formations, classical columns, wind-swept plateaus |
| `region_imenthi` | Imenthi Reach | Persian/Mesopotamian | Volcanic badlands, brass towers, smoke plumes, obsidian formations |

### 2.6 Special/General Locations

| Location ID | Name | Description |
|-------------|------|-------------|
| `special_chess_demon` | Chess Demon Belcour | Mini-dungeon with chess-themed architecture |
| `special_dreamwalking` | Dreamwalking Spaces | Surreal, puzzle-heavy, reflective of past choices |
| `overworld_general` | Overworld General | Generic world map tiles |
| `overworld_space` | Overworld Outer Space | Cosmic void, nebulae, celestial bodies |

---

## 3. RPG Maker MZ Tileset Specifications

### 3.1 Tile Dimensions

**Standard tile size:** 48×48 pixels

### 3.2 Tileset Categories & Dimensions

| Tileset | Dimensions | Purpose | Tile Count |
|---------|------------|---------|------------|
| **A1** | 768×576 px | Animations (water, lava, effects) | 16 columns × 12 rows |
| **A2** | 768×576 px | Ground (terrain autotiles) | 16 columns × 12 rows |
| **A3** | 768×384 px | Buildings (wall autotiles) | 16 columns × 8 rows |
| **A4** | 768×720 px | Walls (dungeon walls) | 16 columns × 15 rows |
| **A5** | 384×768 px | Normal tiles (floor details) | 8 columns × 16 rows |
| **B** | 768×768 px | Upper layer (objects, details) | 16 columns × 16 rows |
| **C** | 768×768 px | Upper layer (additional objects) | 16 columns × 16 rows |
| **D** | 768×768 px | Upper layer (decorations) | 16 columns × 16 rows |
| **E** | 768×768 px | Upper layer (extra elements) | 16 columns × 16 rows |

### 3.3 Alternative Tile Sizes

The app should support RPG Maker MZ's alternative tile size modes:

| Mode | Tile Size | A1/A2 | A3 | A4 | A5 | B-E |
|------|-----------|-------|----|----|----|----|
| 48×48 (default) | 48px | 768×576 | 768×384 | 768×720 | 384×768 | 768×768 |
| 32×32 | 32px | 512×384 | 512×256 | 512×480 | 256×512 | 512×512 |
| 24×24 | 24px | 384×288 | 384×192 | 384×360 | 192×384 | 384×384 |
| 16×16 | 16px | 256×192 | 256×128 | 256×240 | 128×256 | 256×256 |

### 3.4 Autotile Structure (A1-A4)

Autotiles follow a specific 6-tile pattern structure:
- **Tile a:** Representative pattern (display in palette)
- **Tile b:** Pattern with boundaries at each corner
- **Tile c:** Group pattern (center + 8 directional variants)

### 3.5 A1 Block Structure (Animations)

| Block | Purpose | Animation |
|-------|---------|-----------|
| A | Ocean tiles | 3 frames horizontal |
| B | Deep sea tiles | 3 frames horizontal |
| C | Ocean decoration | Static |
| D | Water effects | 3 frames horizontal |
| E | Waterfall tiles | 3 frames vertical |

### 3.6 Output Format Requirements

- **File format:** PNG only
- **Color depth:** 32-bit RGBA (transparency support)
- **Naming convention:** `[Location]_[TilesetType].png`
- **Width constraint:** Must be even number (odd widths cause blur)

---

## 4. Application Architecture

### 4.1 Technology Stack

```
┌─────────────────────────────────────────────────────────────┐
│                    ELECTRON MAIN PROCESS                     │
├─────────────────────────────────────────────────────────────┤
│  - Window Management                                         │
│  - File System Operations                                    │
│  - IPC Communication                                         │
│  - Native Dialog Integration                                 │
│  - Export Pipeline                                           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   ELECTRON RENDERER PROCESS                  │
├─────────────────────────────────────────────────────────────┤
│  React + TypeScript                                          │
│  ├── UI Components (Dropdown menus, preview panels)         │
│  ├── State Management (Zustand or Redux Toolkit)            │
│  └── Canvas Rendering (Pixi.js for preview/manipulation)    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    IMAGE GENERATION LAYER                    │
├─────────────────────────────────────────────────────────────┤
│  FREE TIER PROVIDERS (Priority Order):                       │
│  1. Google Gemini/Imagen-3 (60 req/min, 100 images/day)     │
│  2. Nano Banana (100 credits/month free)                     │
│  3. Local SD (Automatic1111/ComfyUI - unlimited)            │
│  ─────────────────────────────────────────────────────────  │
│  - Rate Limiting & Usage Tracking                           │
│  - Prompt Engineering System                                 │
│  - Tile Assembly Engine                                      │
│  - Format Validation & Correction                           │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Project Structure

```
crimson-eclipse-tileset-generator/
├── package.json
├── electron-builder.json
├── tsconfig.json
├── vite.config.ts
│
├── src/
│   ├── main/                          # Electron main process
│   │   ├── index.ts                   # Entry point
│   │   ├── ipc-handlers.ts            # IPC communication
│   │   ├── file-operations.ts         # Save/export logic
│   │   └── window-manager.ts          # Window creation
│   │
│   ├── renderer/                      # React application
│   │   ├── index.html
│   │   ├── main.tsx                   # React entry
│   │   ├── App.tsx                    # Root component
│   │   │
│   │   ├── components/
│   │   │   ├── Layout/
│   │   │   │   ├── Header.tsx
│   │   │   │   ├── Sidebar.tsx
│   │   │   │   └── MainPanel.tsx
│   │   │   │
│   │   │   ├── Controls/
│   │   │   │   ├── LocationDropdown.tsx
│   │   │   │   ├── TilesetTypeDropdown.tsx
│   │   │   │   ├── TileSizeSelector.tsx
│   │   │   │   ├── ProviderDropdown.tsx      # AI provider selection
│   │   │   │   ├── ProviderStatusBadge.tsx   # Usage indicator
│   │   │   │   └── GenerateButton.tsx
│   │   │   │
│   │   │   ├── Preview/
│   │   │   │   ├── TilesetPreview.tsx
│   │   │   │   ├── TileInspector.tsx
│   │   │   │   └── GridOverlay.tsx
│   │   │   │
│   │   │   └── Export/
│   │   │       ├── ExportDialog.tsx
│   │   │       └── BatchExport.tsx
│   │   │
│   │   ├── stores/
│   │   │   ├── tilesetStore.ts        # Zustand store
│   │   │   └── settingsStore.ts
│   │   │
│   │   ├── hooks/
│   │   │   ├── useGeneration.ts
│   │   │   ├── useProviderStatus.ts        # Provider availability & usage
│   │   │   └── useTilesetValidation.ts
│   │   │
│   │   └── styles/
│   │       ├── globals.css
│   │       └── components/
│   │
│   ├── shared/                        # Shared types & constants
│   │   ├── types/
│   │   │   ├── locations.ts
│   │   │   ├── tilesets.ts
│   │   │   └── generation.ts
│   │   │
│   │   └── constants/
│   │       ├── locations.ts           # Location registry
│   │       ├── tileset-specs.ts       # RPG Maker specs
│   │       └── prompts.ts             # Prompt templates
│   │
│   └── generation/                    # Image generation engine
│       ├── api/
│       │   ├── base-client.ts
│       │   ├── rate-limiter.ts        # Free tier compliance
│       │   ├── usage-tracker.ts       # Daily limit tracking
│       │   └── providers/
│       │       ├── google-gemini.ts   # Primary: Gemini/Imagen-3
│       │       ├── nano-banana.ts     # Secondary: Nano Banana
│       │       └── local.ts           # Fallback: Local SD
│       │
│       ├── prompts/
│       │   ├── prompt-builder.ts
│       │   ├── style-modifiers.ts
│       │   └── location-prompts/
│       │       ├── hub-cities.ts
│       │       ├── font-dungeons.ts
│       │       ├── sin-worlds.ts
│       │       └── overworlds.ts
│       │
│       ├── assembly/
│       │   ├── tileset-assembler.ts
│       │   ├── autotile-generator.ts
│       │   └── format-validator.ts
│       │
│       └── utils/
│           ├── image-processing.ts
│           └── palette-manager.ts
│
├── assets/
│   ├── icons/
│   ├── templates/                     # Reference tileset templates
│   └── palettes/                      # Color palette definitions
│
└── tests/
    ├── unit/
    └── integration/
```

---

## 5. User Interface Design

### 5.1 Main Window Layout

```
┌────────────────────────────────────────────────────────────────────┐
│  ⬛ The Crimson Eclipse - Tileset Generator               [─][□][×]│
├────────────────────────────────────────────────────────────────────┤
│  File   Edit   View   Generate   Settings   Help                   │
├──────────────┬─────────────────────────────────────────────────────┤
│              │                                                     │
│  CONTROLS    │              TILESET PREVIEW                        │
│              │                                                     │
│ ┌──────────┐ │  ┌─────────────────────────────────────────────┐   │
│ │Location  │ │  │                                             │   │
│ │[▼ Vel Sa]│ │  │                                             │   │
│ └──────────┘ │  │                                             │   │
│              │  │         Generated Tileset Preview            │   │
│ ┌──────────┐ │  │                                             │   │
│ │Tileset   │ │  │              (768 x 576)                    │   │
│ │[▼ A1    ]│ │  │                                             │   │
│ └──────────┘ │  │                                             │   │
│              │  │                                             │   │
│ ┌──────────┐ │  │                                             │   │
│ │Tile Size │ │  └─────────────────────────────────────────────┘   │
│ │[▼ 48x48]│ │                                                     │
│ └──────────┘ │  ┌─────────────────────────────────────────────┐   │
│              │  │ TILE INSPECTOR                              │   │
│ ┌──────────┐ │  │ Selected: [A1-0,0]  Size: 48x48            │   │
│ │Provider  │ │  │ Type: Ocean Base    Animated: Yes (3fr)     │   │
│ │[▼Google ]│ │  └─────────────────────────────────────────────┘   │
│ └──────────┘ │                                                     │
│              │  ┌─────────────────────────────────────────────┐   │
│ ───────────  │  │ GENERATION LOG                              │   │
│              │  │ > Initializing location: Vel Sahrad...     │   │
│ [⚡Generate] │  │ > Using provider: Google Imagen-3           │   │
│              │  │ > Generating A1 water tiles...             │   │
│ ───────────  │  │ > Applying Gothic/Dark Fantasy style...     │   │
│              │  └─────────────────────────────────────────────┘   │
│ FREE TIER    │                                                     │
│ ┌──────────┐ │                                                     │
│ │Google    │ │                                                     │
│ │[███░░] 62│ │  (62/100 images today)                             │
│ │NanoBanana│ │                                                     │
│ │[█░░░░] 23│ │  (23/100 credits this month)                       │
│ └──────────┘ │                                                     │
│              │                                                     │
├──────────────┴─────────────────────────────────────────────────────┤
│  Status: Ready │ Provider: Google │ Tileset: A1 │ Free tier: 38%  │
└────────────────────────────────────────────────────────────────────┘
```

### 5.2 Location Dropdown Structure

The Location dropdown should be organized hierarchically:

```
┌─────────────────────────────────────┐
│ Location                        [▼] │
├─────────────────────────────────────┤
│ ── HUB CITIES ──                    │
│    Vel Sahrad (London)              │
│    Val Duivra (France)              │
│    Skýthenos Cloud City             │
│ ── ACT I: FONT DUNGEONS ──          │
│    Garn Caladrûn (Earth)            │
│    Khenenu Deep (Water)             │
│    Skývaldr Cliffs (Air)            │
│    Volkheth Sármaar (Fire)          │
│    Sanctum of Hollow Winds          │
│ ── ACT II: SIN WORLDS ──            │
│    Vault of Hollow Gold (Greed)     │
│    Crimson Mirage Temple (Lust)     │
│    Maw of Endless Bloom (Gluttony)  │
│    Garden of Withered Light (Sloth) │
│    Fortress of Broken Voices (Wrath)│
│    Mirror Sanctum (Envy)            │
│    The Ecliptic Throne (Pride)      │
│ ── ACT III: REVELATION ──           │
│    The Lachrymal Gate               │
│    The Vörðr Restoration            │
│ ── REGIONAL OVERWORLDS ──           │
│    Xoch'Zan Jungle                  │
│    Pelmara Coast                    │
│    Skýthenos Region                 │
│    Imenthi Reach                    │
│ ── SPECIAL ──                       │
│    Chess Demon Belcour              │
│    Dreamwalking Spaces              │
│ ── GENERAL ──                       │
│    Overworld General                │
│    Overworld Outer Space            │
└─────────────────────────────────────┘
```

### 5.3 Tileset Type Dropdown

```
┌─────────────────────────────────────┐
│ Tileset Format                  [▼] │
├─────────────────────────────────────┤
│ ── LAYER A (GROUND/AUTOTILES) ──    │
│    A1 - Animations (768×576)        │
│    A2 - Ground (768×576)            │
│    A3 - Buildings (768×384)         │
│    A4 - Walls (768×720)             │
│    A5 - Normal (384×768)            │
│ ── LAYER B-E (UPPER/OBJECTS) ──     │
│    B - Objects (768×768)            │
│    C - Additional (768×768)         │
│    D - Decorations (768×768)        │
│    E - Extra (768×768)              │
└─────────────────────────────────────┘
```

### 5.4 AI Provider Dropdown

```
┌─────────────────────────────────────┐
│ AI Provider                     [▼] │
├─────────────────────────────────────┤
│ ── CLOUD PROVIDERS (FREE TIER) ──   │
│  ● Google Gemini/Imagen-3           │
│      └─ 62/100 images today         │
│    Nano Banana                      │
│      └─ 23/100 credits this month   │
│ ── LOCAL GENERATION ──              │
│    Local (Automatic1111)            │
│      └─ Unlimited · Requires setup  │
│    Local (ComfyUI)                  │
│      └─ Unlimited · Requires setup  │
│ ── AUTO ──                          │
│    Smart Auto-Select                │
│      └─ Uses best available         │
└─────────────────────────────────────┘
```

**Provider Dropdown Behavior:**

| Selection | Behavior |
|-----------|----------|
| Google Gemini/Imagen-3 | Use Google API exclusively; warn if limit reached |
| Nano Banana | Use Nano Banana API exclusively; warn if credits low |
| Local (Automatic1111) | Use local SD at `localhost:7860` |
| Local (ComfyUI) | Use local ComfyUI at `localhost:8188` |
| Smart Auto-Select | Automatically choose based on availability and limits |

**Visual Status Indicators:**

```typescript
// Color-coded status for each provider in dropdown
interface ProviderDropdownItem {
  id: 'google' | 'nanoBanana' | 'local_auto1111' | 'local_comfyui' | 'auto';
  name: string;
  category: 'cloud' | 'local' | 'auto';
  available: boolean;
  usageText: string;
  statusDot: 'green' | 'yellow' | 'red' | 'gray';
}

// Status dot meanings:
// 🟢 Green  = Available, <50% usage
// 🟡 Yellow = Available, 50-90% usage  
// 🔴 Red    = Available, >90% usage (near limit)
// ⚫ Gray   = Not available/not configured

const providerItems: ProviderDropdownItem[] = [
  {
    id: 'google',
    name: 'Google Gemini/Imagen-3',
    category: 'cloud',
    available: true,
    usageText: '62/100 images today',
    statusDot: 'yellow'
  },
  {
    id: 'nanoBanana', 
    name: 'Nano Banana',
    category: 'cloud',
    available: true,
    usageText: '23/100 credits this month',
    statusDot: 'green'
  },
  {
    id: 'local_auto1111',
    name: 'Local (Automatic1111)',
    category: 'local',
    available: false,
    usageText: 'Not connected',
    statusDot: 'gray'
  },
  {
    id: 'local_comfyui',
    name: 'Local (ComfyUI)',
    category: 'local', 
    available: true,
    usageText: 'Unlimited · Connected',
    statusDot: 'green'
  },
  {
    id: 'auto',
    name: 'Smart Auto-Select',
    category: 'auto',
    available: true,
    usageText: 'Uses best available',
    statusDot: 'green'
  }
];
```

### 5.5 Provider Dropdown Component

```typescript
// renderer/components/Controls/ProviderDropdown.tsx

import React from 'react';
import { useSettingsStore } from '../../stores/settingsStore';
import { useProviderStatus } from '../../hooks/useProviderStatus';

interface Props {
  onChange?: (providerId: string) => void;
}

export const ProviderDropdown: React.FC<Props> = ({ onChange }) => {
  const { selectedProvider, setSelectedProvider } = useSettingsStore();
  const { providers, refreshStatus } = useProviderStatus();

  const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const providerId = e.target.value;
    setSelectedProvider(providerId);
    onChange?.(providerId);
  };

  const getStatusColor = (status: string): string => {
    switch (status) {
      case 'green': return '#22c55e';
      case 'yellow': return '#eab308';
      case 'red': return '#ef4444';
      default: return '#6b7280';
    }
  };

  return (
    <div className="provider-dropdown">
      <label htmlFor="provider-select">AI Provider</label>
      <select 
        id="provider-select"
        value={selectedProvider}
        onChange={handleChange}
      >
        <optgroup label="Cloud Providers (Free Tier)">
          {providers.filter(p => p.category === 'cloud').map(provider => (
            <option 
              key={provider.id} 
              value={provider.id}
              disabled={!provider.available}
            >
              {provider.available ? '●' : '○'} {provider.name} — {provider.usageText}
            </option>
          ))}
        </optgroup>
        <optgroup label="Local Generation">
          {providers.filter(p => p.category === 'local').map(provider => (
            <option 
              key={provider.id} 
              value={provider.id}
              disabled={!provider.available}
            >
              {provider.available ? '●' : '○'} {provider.name} — {provider.usageText}
            </option>
          ))}
        </optgroup>
        <optgroup label="Automatic">
          {providers.filter(p => p.category === 'auto').map(provider => (
            <option key={provider.id} value={provider.id}>
              ◆ {provider.name}
            </option>
          ))}
        </optgroup>
      </select>
      
      <button 
        className="refresh-status" 
        onClick={refreshStatus}
        title="Refresh provider status"
      >
        ↻
      </button>
    </div>
  );
};
```

---

## 6. Prompt Engineering System

### 6.1 Base Style Prompt

All generations will include this foundational style directive:

```
STYLE FOUNDATION:
- Gothic dark fantasy aesthetic
- Sci-fi undertones with ancient technology
- Top-down JRPG perspective (3/4 view implied depth)
- Pixel art, clean edges, limited anti-aliasing
- 16-32 color palette per tileset
- High contrast, readable silhouettes
- Consistent light source (top-left default)
- Atmospheric depth through color temperature
- Organic meets mechanical visual tension
```

### 6.2 Location-Specific Prompt Templates

#### Hub City Example: Vel Sahrad

```typescript
const velSahradPrompts = {
  base: `
    Victorian Gothic architecture, London-inspired dark fantasy city
    Cobblestone streets, gas lamp lighting, wrought iron fences
    Fog-shrouded atmosphere, industrial smoke stacks
    Clockwork mechanisms, brass fixtures, weathered stone
    Crimson accents reflecting the cosmic eclipse theme
    Abandoned grandeur mixed with urban decay
  `,
  
  A1_water: `
    Polluted canal water, oil-slick reflections
    Sewer grates with eerie glow beneath
    Rain-slicked cobblestones with puddle reflections
    Dark water with subtle bioluminescent corruption
  `,
  
  A2_ground: `
    Cracked cobblestone variations
    Worn flagstone paths
    Industrial metal grating
    Corrupted grass patches with crimson tints
    Coal-stained earth
  `,
  
  B_objects: `
    Victorian street lamps (lit and broken variants)
    Wrought iron benches and fences
    Clockwork debris and gears
    Stacked crates and barrels
    Newspaper stands, post boxes
    Steam vents and pipes
  `
};
```

#### Sin World Example: Vault of Hollow Gold

```typescript
const vaultHollowGoldPrompts = {
  base: `
    Endless treasury chambers, impossible architecture of wealth
    Dragon hoard aesthetics, mountains of coins and gems
    Bank vault mechanisms, massive gear-driven doors
    Gold-plated everything with corruption creeping through
    Green-tinged lighting from cursed treasure
    Excessive opulence masking decay and emptiness
  `,
  
  A1_water: `
    Liquid gold pools (animated shimmer)
    Molten currency flows
    Mercury-like cursed metals
    Coin-filled fountain basins
  `,
  
  A4_walls: `
    Stacked gold bar walls
    Vault door segments (massive circular)
    Safe deposit box arrays
    Jewel-encrusted stone walls
    Counting house architecture
  `,
  
  B_objects: `
    Treasure chests (open/closed/trapped variants)
    Coin piles of varying sizes
    Gem clusters and crown jewels
    Scales and weights
    Ledger books and abacuses
    Skeletal remains clutching gold
  `
};
```

### 6.3 Tileset-Specific Constraints

Each tileset type requires specific prompt additions:

```typescript
const tilesetConstraints = {
  A1: `
    ANIMATION REQUIREMENTS:
    - Water tiles: 3-frame horizontal animation loop
    - Must tile seamlessly in all directions
    - Include deep water variant for boundaries
    - Waterfall: 2-tile wide, 3-frame vertical loop
    - Special effects (lava, acid, etc.) with glow
  `,
  
  A2: `
    GROUND AUTOTILE REQUIREMENTS:
    - Center tile + 8 directional edge variants
    - Must support full autotile boundary detection
    - Primary terrain + decorative overlay pairs
    - Clear visual distinction between terrain types
    - Forest-type tiles need transparency handling
  `,
  
  A3: `
    BUILDING AUTOTILE REQUIREMENTS:
    - Roof/wall tiles with automatic shadow casting
    - Must work in vertical stacking (2+ tiles)
    - 8 horizontal slots, 4 vertical rows
    - Group pattern formation only
  `,
  
  A4: `
    WALL AUTOTILE REQUIREMENTS:
    - Dungeon wall focus
    - Vertical shadow auto-generation support
    - 8 columns, alternating basic + group patterns
    - 15 tile rows total
  `,
  
  A5: `
    NORMAL TILE REQUIREMENTS:
    - No autotile behavior, simple placement
    - Floor detail tiles for dungeons
    - 8 columns × 16 rows
    - Rows 3, 5, 7 reserved for dungeon floors
  `,
  
  'B-E': `
    UPPER LAYER REQUIREMENTS:
    - Objects, decorations, props
    - Transparency for layering
    - Top-left cell must be empty (represents "no tile")
    - 16×16 grid arrangement
    - Varying tile footprints (1×1, 1×2, 2×2, etc.)
  `
};
```

---

## 7. Image Generation Pipeline

### 7.1 Generation Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                    GENERATION PIPELINE                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 1. PROMPT ASSEMBLY                                              │
│    ├── Load location base prompt                                │
│    ├── Append tileset-specific constraints                      │
│    ├── Add style foundation                                     │
│    └── Inject technical specifications (dimensions, format)     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. TILE GENERATION                                              │
│    ├── For A1-A4: Generate autotile components separately       │
│    │   ├── Generate representative tile                         │
│    │   ├── Generate boundary variants                           │
│    │   └── Generate group pattern center + edges                │
│    ├── For A5, B-E: Generate tile sections in batches           │
│    └── Apply post-processing (palette reduction, edge cleanup)  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. ASSEMBLY                                                     │
│    ├── Validate individual tile dimensions                      │
│    ├── Assemble into correct tileset grid layout                │
│    ├── Verify autotile pattern compliance                       │
│    └── Check for proper transparency handling                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. VALIDATION                                                   │
│    ├── Verify final dimensions match specification              │
│    ├── Check image width is even number                         │
│    ├── Validate PNG format and color depth                      │
│    └── Preview rendering test                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 5. EXPORT                                                       │
│    ├── Apply naming convention                                  │
│    ├── Save to specified output directory                       │
│    └── Generate metadata JSON (optional)                        │
└─────────────────────────────────────────────────────────────────┘
```

### 7.2 Autotile Generation Strategy

Autotiles require careful component generation:

```typescript
interface AutotileComponents {
  // The 6-tile basic pattern
  representative: ImageBuffer;      // Tile 'a' - shown in editor palette
  cornerBoundaries: ImageBuffer;    // Tile 'b' - boundaries at corners
  groupCenter: ImageBuffer;         // Tile 'c' top-left - isolated center
  groupEdges: ImageBuffer;          // Tile 'c' remaining - 8-directional edges
}

async function generateAutotile(
  location: Location,
  terrainType: string,
  tileSize: number = 48
): Promise<AutotileComponents> {
  // 1. Generate the "ideal" center tile first
  const centerPrompt = buildPrompt(location, terrainType, 'center');
  const center = await generateTile(centerPrompt, tileSize, tileSize);
  
  // 2. Generate edge/boundary variants based on center
  const edgePrompt = buildPrompt(location, terrainType, 'edges', center);
  const edges = await generateEdgeVariants(edgePrompt, center);
  
  // 3. Assemble into 6-tile pattern
  return assembleAutotilePattern(center, edges);
}
```

### 7.3 Animation Frame Generation (A1)

```typescript
async function generateAnimatedTile(
  location: Location,
  animationType: 'water' | 'lava' | 'waterfall' | 'effect',
  frameCount: number = 3
): Promise<ImageBuffer[]> {
  const frames: ImageBuffer[] = [];
  
  // Generate base frame
  const basePrompt = buildPrompt(location, animationType, 'base');
  frames[0] = await generateTile(basePrompt);
  
  // Generate variation frames maintaining consistency
  for (let i = 1; i < frameCount; i++) {
    const variantPrompt = buildPrompt(
      location, 
      animationType, 
      `frame_${i}`,
      { referenceFrame: frames[0], frameIndex: i }
    );
    frames[i] = await generateTile(variantPrompt);
  }
  
  return frames;
}
```

---

## 8. Format Validation System

### 8.1 Validation Rules

```typescript
interface ValidationResult {
  valid: boolean;
  errors: ValidationError[];
  warnings: ValidationWarning[];
  autoFixable: boolean;
}

const validationRules: ValidationRule[] = [
  {
    id: 'dimension_check',
    description: 'Verify tileset dimensions match specification',
    validate: (image, tilesetType, tileSize) => {
      const expected = getTilesetDimensions(tilesetType, tileSize);
      return image.width === expected.width && 
             image.height === expected.height;
    },
    autoFix: (image, tilesetType, tileSize) => {
      return resizeCanvas(image, getTilesetDimensions(tilesetType, tileSize));
    }
  },
  
  {
    id: 'even_width',
    description: 'Image width must be even to prevent blur',
    validate: (image) => image.width % 2 === 0,
    autoFix: (image) => padWidth(image)
  },
  
  {
    id: 'png_format',
    description: 'Output must be PNG format',
    validate: (image) => image.format === 'png',
    autoFix: (image) => convertToPNG(image)
  },
  
  {
    id: 'transparency_support',
    description: 'Image must support transparency (RGBA)',
    validate: (image) => image.channels === 4,
    autoFix: (image) => addAlphaChannel(image)
  },
  
  {
    id: 'b_tileset_empty_corner',
    description: 'B tileset top-left tile must be empty',
    validate: (image, tilesetType) => {
      if (tilesetType !== 'B') return true;
      return isTransparent(image, 0, 0, 48, 48);
    },
    autoFix: (image) => clearTopLeftTile(image)
  }
];
```

### 8.2 Dimension Reference Table

```typescript
const TILESET_DIMENSIONS = {
  48: { // Default 48x48 tiles
    A1: { width: 768, height: 576, cols: 16, rows: 12 },
    A2: { width: 768, height: 576, cols: 16, rows: 12 },
    A3: { width: 768, height: 384, cols: 16, rows: 8 },
    A4: { width: 768, height: 720, cols: 16, rows: 15 },
    A5: { width: 384, height: 768, cols: 8, rows: 16 },
    B:  { width: 768, height: 768, cols: 16, rows: 16 },
    C:  { width: 768, height: 768, cols: 16, rows: 16 },
    D:  { width: 768, height: 768, cols: 16, rows: 16 },
    E:  { width: 768, height: 768, cols: 16, rows: 16 },
  },
  32: { // 32x32 tiles
    A1: { width: 512, height: 384, cols: 16, rows: 12 },
    A2: { width: 512, height: 384, cols: 16, rows: 12 },
    A3: { width: 512, height: 256, cols: 16, rows: 8 },
    A4: { width: 512, height: 480, cols: 16, rows: 15 },
    A5: { width: 256, height: 512, cols: 8, rows: 16 },
    B:  { width: 512, height: 512, cols: 16, rows: 16 },
    C:  { width: 512, height: 512, cols: 16, rows: 16 },
    D:  { width: 512, height: 512, cols: 16, rows: 16 },
    E:  { width: 512, height: 512, cols: 16, rows: 16 },
  },
  // ... 24 and 16 pixel variants
};
```

---

## 9. Export System

### 9.1 Naming Convention

```
[LocationID]_[TilesetType]_[TileSize].png

Examples:
- hub_vel_sahrad_A1_48.png
- sin_vault_gold_B_48.png
- font_khenenu_deep_A2_32.png
```

### 9.2 Batch Export Structure

```
Export_YYYY-MM-DD_HHMMSS/
├── Vel_Sahrad/
│   ├── hub_vel_sahrad_A1_48.png
│   ├── hub_vel_sahrad_A2_48.png
│   ├── hub_vel_sahrad_A3_48.png
│   ├── hub_vel_sahrad_A4_48.png
│   ├── hub_vel_sahrad_A5_48.png
│   ├── hub_vel_sahrad_B_48.png
│   ├── hub_vel_sahrad_C_48.png
│   ├── hub_vel_sahrad_D_48.png
│   └── hub_vel_sahrad_E_48.png
├── Vault_of_Hollow_Gold/
│   └── ...
├── metadata.json
└── generation_log.txt
```

### 9.3 Metadata Output

```json
{
  "generationDate": "2025-01-16T12:00:00Z",
  "applicationVersion": "1.0.0",
  "targetEngine": "RPG Maker MZ",
  "tilesets": [
    {
      "filename": "hub_vel_sahrad_A1_48.png",
      "location": "Vel Sahrad",
      "locationId": "hub_vel_sahrad",
      "tilesetType": "A1",
      "tileSize": 48,
      "dimensions": { "width": 768, "height": 576 },
      "promptUsed": "...",
      "generationTime": 45.2,
      "validationPassed": true
    }
  ]
}
```

---

## 10. Settings & Configuration

### 10.1 Application Settings

```typescript
interface AppSettings {
  // Output settings
  outputDirectory: string;
  namingConvention: 'snake_case' | 'PascalCase' | 'kebab-case';
  createSubfolders: boolean;
  generateMetadata: boolean;
  
  // Generation settings
  defaultTileSize: 48 | 32 | 24 | 16;
  apiProvider: 'google' | 'nanoBanana' | 'local';
  googleApiKey: string;
  nanoBananaApiKey: string;
  maxRetries: number;
  respectFreeTierLimits: boolean;
  dailyGenerationBudget: number;  // Track free tier usage
  
  // Style settings
  paletteMode: 'auto' | 'limited_16' | 'limited_32' | 'full';
  edgeSmoothing: boolean;
  contrastBoost: number;
  
  // Preview settings
  gridOverlay: boolean;
  previewScale: number;
  darkMode: boolean;
}
```

### 10.2 API Configuration

The application prioritizes free-tier AI services for accessibility:

```typescript
interface APIConfig {
  // PRIMARY: Google Gemini (Free tier: 60 requests/minute)
  google: {
    provider: 'gemini';
    model: 'gemini-2.0-flash-exp' | 'imagen-3';  // Imagen-3 for image gen
    apiKey: string;
    region: 'us-central1' | 'europe-west1';
    freeTierLimits: {
      requestsPerMinute: 60,
      requestsPerDay: 1500,
      imagesPerDay: 100  // Imagen-3 free tier
    };
  };
  
  // SECONDARY: Nano Banana (Free tier available)
  nanoBanana: {
    provider: 'nanobanana';
    endpoint: 'https://api.nanobanana.com/v1';
    model: 'pixel-art-xl' | 'stable-diffusion-xl';
    apiKey: string;
    freeTierLimits: {
      creditsPerMonth: 100,
      imagesPerCredit: 1
    };
  };
  
  // FALLBACK: Local generation (no API needed)
  local: {
    provider: 'local';
    endpoint: 'http://localhost:7860';  // Automatic1111 or ComfyUI
    model: 'sd-xl-base' | 'pixel-art-lora';
    enabled: boolean;
  };
}

// Provider priority order
const PROVIDER_PRIORITY = ['google', 'nanoBanana', 'local'] as const;
```

#### Google Gemini Setup

```typescript
// Google AI Studio API (free tier)
import { GoogleGenerativeAI } from '@google/generative-ai';

const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY);

// For text-to-image with Imagen 3
const imagenModel = genAI.getGenerativeModel({ 
  model: 'imagen-3.0-generate-002'
});

// Rate limiting for free tier compliance
const rateLimiter = {
  google: new RateLimiter({
    tokensPerInterval: 60,
    interval: 'minute'
  })
};
```

#### Nano Banana Setup

```typescript
// Nano Banana free tier integration
interface NanoBananaRequest {
  prompt: string;
  negative_prompt?: string;
  width: number;
  height: number;
  steps: number;
  guidance_scale: number;
  model: string;
}

async function generateWithNanoBanana(
  prompt: string,
  width: number,
  height: number
): Promise<Buffer> {
  const response = await fetch('https://api.nanobanana.com/v1/generate', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.NANOBANANA_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      prompt: prompt,
      negative_prompt: 'blurry, low quality, watermark, text',
      width: width,
      height: height,
      steps: 30,
      guidance_scale: 7.5,
      model: 'pixel-art-xl'
    })
  });
  
  const data = await response.json();
  return Buffer.from(data.image, 'base64');
}
```

---

## 11. Development Phases

### Phase 1: Foundation (Weeks 1-2)

**Objectives:**
- Set up Electron + React + TypeScript + Vite project
- Implement main window layout
- Create dropdown components with full location/tileset data
- Basic file save/export functionality

**Deliverables:**
- Working Electron shell
- Functional UI with all dropdowns populated
- Settings persistence

### Phase 2: Generation Core (Weeks 3-4)

**Objectives:**
- Implement prompt engineering system
- Integrate Google Gemini/Imagen-3 API (free tier)
- Add Nano Banana as secondary provider
- Configure local fallback (Automatic1111/ComfyUI)
- Create basic tile generation pipeline
- Implement format validation
- Add rate limiting for free tier compliance

**Deliverables:**
- Working single-tile generation
- Multi-provider support with automatic fallback
- Prompt builder with location awareness
- Basic validation checks
- Free tier usage tracking dashboard

### Phase 3: Tileset Assembly (Weeks 5-6)

**Objectives:**
- Implement autotile pattern generation
- Create tileset assembly engine
- Handle animation frames (A1)
- Complete all tileset type support

**Deliverables:**
- Full A1-A5, B-E tileset generation
- Autotile boundary handling
- Animation support

### Phase 4: Polish & Export (Weeks 7-8)

**Objectives:**
- Implement batch export system
- Add preview with grid overlay
- Complete validation with auto-fix
- Add metadata generation

**Deliverables:**
- Batch export functionality
- Full validation suite
- Production-ready export

### Phase 5: Testing & Release (Weeks 9-10)

**Objectives:**
- Comprehensive testing across all locations
- Performance optimization
- Documentation
- Build distribution packages

**Deliverables:**
- Windows/Mac/Linux builds
- User documentation
- Release candidate

---

## 12. Technical Considerations

### 12.1 Electron Security

```typescript
// main/index.ts - Security best practices
const mainWindow = new BrowserWindow({
  webPreferences: {
    nodeIntegration: false,
    contextIsolation: true,
    preload: path.join(__dirname, 'preload.js'),
    sandbox: true
  }
});
```

### 12.2 IPC Communication

```typescript
// Secure IPC channels
const CHANNELS = {
  GENERATE_TILESET: 'tileset:generate',
  EXPORT_FILE: 'file:export',
  LOAD_SETTINGS: 'settings:load',
  SAVE_SETTINGS: 'settings:save',
  VALIDATE_TILESET: 'tileset:validate'
} as const;
```

### 12.3 Image Processing Dependencies

```json
{
  "dependencies": {
    "@google/generative-ai": "^0.21.0",  // Google Gemini/Imagen
    "sharp": "^0.33.0",                   // Image manipulation
    "pngjs": "^7.0.0",                    // PNG parsing
    "pixi.js": "^8.0.0",                  // Canvas rendering
    "color": "^4.2.0",                    // Color manipulation
    "bottleneck": "^2.19.5"               // Rate limiting
  }
}
```

### 12.4 Cross-Platform Considerations

- Use `path.join()` for all file paths
- Test on Windows, macOS, and Linux
- Handle different DPI scaling
- Use native dialogs via Electron APIs

---

## 13. Error Handling

### 13.1 Generation Errors

```typescript
enum GenerationErrorCode {
  // API Errors
  API_RATE_LIMIT = 'API_RATE_LIMIT',
  API_DAILY_LIMIT = 'API_DAILY_LIMIT',      // Free tier daily cap
  API_MONTHLY_LIMIT = 'API_MONTHLY_LIMIT',  // Free tier monthly cap
  API_CONTENT_FILTER = 'API_CONTENT_FILTER',
  API_QUOTA_EXCEEDED = 'API_QUOTA_EXCEEDED',
  API_KEY_INVALID = 'API_KEY_INVALID',
  
  // Provider Errors
  PROVIDER_UNAVAILABLE = 'PROVIDER_UNAVAILABLE',
  ALL_PROVIDERS_EXHAUSTED = 'ALL_PROVIDERS_EXHAUSTED',
  
  // Processing Errors
  INVALID_DIMENSIONS = 'INVALID_DIMENSIONS',
  ASSEMBLY_FAILED = 'ASSEMBLY_FAILED',
  VALIDATION_FAILED = 'VALIDATION_FAILED',
  EXPORT_FAILED = 'EXPORT_FAILED'
}

interface GenerationError {
  code: GenerationErrorCode;
  message: string;
  recoverable: boolean;
  suggestedAction: string;
  alternativeProvider?: string;  // Suggest fallback
}
```

### 13.2 Recovery Strategies

| Error | Recovery Strategy |
|-------|-------------------|
| API Rate Limit | Wait + retry, or switch to Nano Banana |
| API Daily Limit | Switch provider, or wait until reset |
| API Monthly Limit | Switch to local generation |
| Content Filter | Adjust prompt, retry with alternatives |
| Provider Unavailable | Automatic fallback to next provider |
| All Providers Exhausted | Prompt user to configure local SD |
| Invalid Dimensions | Auto-resize/crop to specification |
| Assembly Failed | Regenerate failed components |
| Validation Failed | Apply auto-fix if available |

### 13.3 Free Tier Management

```typescript
interface FreeTierUsage {
  google: {
    imagesGeneratedToday: number;
    dailyLimit: 100;
    requestsThisMinute: number;
    minuteLimit: 60;
    resetsAt: Date;
  };
  nanoBanana: {
    creditsUsedThisMonth: number;
    monthlyLimit: 100;
    resetsAt: Date;
  };
}

// Automatic provider switching when limits approached
function selectProvider(usage: FreeTierUsage): Provider {
  if (usage.google.imagesGeneratedToday < 95) {
    return 'google';
  } else if (usage.nanoBanana.creditsUsedThisMonth < 95) {
    return 'nanoBanana';
  } else {
    return 'local';
  }
}

// Pre-generation budget check
function canGenerateTileset(
  tilesetType: string, 
  usage: FreeTierUsage
): { canGenerate: boolean; provider: Provider; estimatedCost: number } {
  const estimatedImages = getEstimatedImageCount(tilesetType);
  // ... budget calculation logic
}
```

---

## 14. Future Enhancements

### 14.1 Potential Features

- **Template Library:** Pre-made tileset templates for common elements
- **Palette Editor:** Custom color palette definition and application
- **Tile Painter:** Manual touch-up tool for generated tiles
- **Animation Preview:** Real-time animation playback for A1 tiles
- **Map Preview:** Test tilesets in a mock map environment
- **Style Transfer:** Apply style from reference images
- **Batch Variations:** Generate multiple variations per location

### 14.2 Integration Possibilities

- Direct RPG Maker MZ project import/export
- Cloud storage for generated assets
- Team collaboration features
- Version control for tileset iterations

---

## 15. Appendix

### A. Complete Location List (Copy-Paste Ready)

```typescript
export const LOCATIONS = [
  // Hub Cities
  { id: 'hub_vel_sahrad', name: 'Vel Sahrad', category: 'Hub Cities', inspiration: 'London' },
  { id: 'hub_val_duivra', name: 'Val Duivra', category: 'Hub Cities', inspiration: 'France' },
  { id: 'hub_skythenos', name: 'Skýthenos Cloud City', category: 'Hub Cities', inspiration: 'Greece' },
  
  // Act I: Font Dungeons
  { id: 'font_garn_caladrun', name: 'Garn Caladrûn', category: 'Font Dungeons', element: 'Earth' },
  { id: 'font_khenenu_deep', name: 'Khenenu Deep', category: 'Font Dungeons', element: 'Water' },
  { id: 'font_skyvaldr_cliffs', name: 'Skývaldr Cliffs', category: 'Font Dungeons', element: 'Air' },
  { id: 'font_volkheth_sarmaar', name: 'Volkheth Sármaar', category: 'Font Dungeons', element: 'Fire' },
  { id: 'font_sanctum_hollow', name: 'Sanctum of Hollow Winds', category: 'Font Dungeons', element: 'Harmony' },
  
  // Act II: Sin Worlds
  { id: 'sin_vault_gold', name: 'Vault of Hollow Gold', category: 'Sin Worlds', sin: 'Greed', chakra: 'Root' },
  { id: 'sin_crimson_mirage', name: 'Crimson Mirage Temple', category: 'Sin Worlds', sin: 'Lust', chakra: 'Sacral' },
  { id: 'sin_maw_bloom', name: 'Maw of Endless Bloom', category: 'Sin Worlds', sin: 'Gluttony', chakra: 'Solar Plexus' },
  { id: 'sin_garden_withered', name: 'Garden of Withered Light', category: 'Sin Worlds', sin: 'Sloth', chakra: 'Heart' },
  { id: 'sin_fortress_voices', name: 'Fortress of Broken Voices', category: 'Sin Worlds', sin: 'Wrath', chakra: 'Throat' },
  { id: 'sin_mirror_sanctum', name: 'Mirror Sanctum', category: 'Sin Worlds', sin: 'Envy', chakra: 'Third Eye' },
  { id: 'sin_ecliptic_throne', name: 'The Ecliptic Throne', category: 'Sin Worlds', sin: 'Pride', chakra: 'Crown' },
  
  // Act III: Revelation
  { id: 'rev_lachrymal_gate', name: 'The Lachrymal Gate', category: 'Revelation', theme: 'Eighth Chakra' },
  { id: 'rev_vordr_restoration', name: 'The Vörðr Restoration', category: 'Revelation', theme: 'Barrier Healing' },
  
  // Regional Overworlds
  { id: 'region_xochzan', name: 'Xoch\'Zan Jungle', category: 'Overworlds', inspiration: 'Aztec' },
  { id: 'region_pelmara', name: 'Pelmara Coast', category: 'Overworlds', inspiration: 'Egyptian' },
  { id: 'region_skythenos', name: 'Skýthenos Region', category: 'Overworlds', inspiration: 'Greek' },
  { id: 'region_imenthi', name: 'Imenthi Reach', category: 'Overworlds', inspiration: 'Persian' },
  
  // Special
  { id: 'special_chess_demon', name: 'Chess Demon Belcour', category: 'Special' },
  { id: 'special_dreamwalking', name: 'Dreamwalking Spaces', category: 'Special' },
  
  // General
  { id: 'overworld_general', name: 'Overworld General', category: 'General' },
  { id: 'overworld_space', name: 'Overworld Outer Space', category: 'General' },
];
```

### B. Tileset Type Reference

```typescript
export const TILESET_TYPES = [
  { id: 'A1', name: 'A1 - Animations', category: 'Layer A', width: 768, height: 576 },
  { id: 'A2', name: 'A2 - Ground', category: 'Layer A', width: 768, height: 576 },
  { id: 'A3', name: 'A3 - Buildings', category: 'Layer A', width: 768, height: 384 },
  { id: 'A4', name: 'A4 - Walls', category: 'Layer A', width: 768, height: 720 },
  { id: 'A5', name: 'A5 - Normal', category: 'Layer A', width: 384, height: 768 },
  { id: 'B', name: 'B - Objects', category: 'Layer B-E', width: 768, height: 768 },
  { id: 'C', name: 'C - Additional', category: 'Layer B-E', width: 768, height: 768 },
  { id: 'D', name: 'D - Decorations', category: 'Layer B-E', width: 768, height: 768 },
  { id: 'E', name: 'E - Extra', category: 'Layer B-E', width: 768, height: 768 },
];
```

---

*Document Version: 1.0*  
*Last Updated: January 2025*  
*The Crimson Eclipse © 2025*
