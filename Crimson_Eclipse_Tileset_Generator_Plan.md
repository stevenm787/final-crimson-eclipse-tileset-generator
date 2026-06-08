# The Crimson Eclipse: Tileset Generator

## Flutter Application Development Plan v2.0

**Version:** 2.0
**Target Engine:** RPG Maker MZ / RPG Architect
**Visual Style:** Gothic / Sci-Fi / Dark Fantasy / Top-Down JRPG / Pixel Art
**Platform:** Flutter (macOS, iOS native)
**AI Backend:** HuggingFace Open-Source Models + LoRAs

---

## 1. Executive Summary

This document outlines the complete development plan for a **Flutter-based** tileset generation application designed specifically for *The Crimson Eclipse*. The application generates properly-formatted tileset assets that strictly adhere to RPG Maker MZ / RPG Architect specifications while maintaining the game's distinctive Gothic/Sci-Fi/Dark Fantasy aesthetic.

### What Changed (v1 -> v2)

| Aspect | v1 (Old) | v2 (Current) |
|--------|----------|--------------|
| **Framework** | Electron + React + TypeScript | Flutter (Dart) |
| **Platforms** | Windows/Mac/Linux desktop | macOS + iOS native |
| **Primary AI** | Google Gemini/Imagen-3 | HuggingFace Inference API (SDXL + Pixel Art LoRAs) |
| **Secondary AI** | Nano Banana | Google Gemini/Imagen-3 |
| **Fallback AI** | Local SD only | Local SD (Automatic1111/ComfyUI) |
| **Target Format** | RPG Maker MZ only | RPG Maker MZ + RPG Architect |
| **Prompt Library** | Inline TypeScript templates | Crimson Eclipse Architect Library (PDF-sourced) |
| **Distribution** | Electron builds | App Store / TestFlight |

### Key Advantages of v2

- **Native performance** on macOS and iOS via Flutter
- **Free, open-source AI models** via HuggingFace (no API cost concerns)
- **Pixel art LoRAs** specifically trained for 48px game assets
- **RPG Architect format** support alongside RPG Maker MZ
- **Mobile access** on iOS for on-the-go asset review and generation
- **TestFlight distribution** for easy testing across devices

---

## 2. AI Model Stack

### 2.1 Recommended Models (HuggingFace)

#### Base Models

| Model | HuggingFace ID | Type | Best For |
|-------|---------------|------|----------|
| **SDXL Base** | `stabilityai/stable-diffusion-xl-base-1.0` | Base | General high-quality generation |
| **FLUX.1 Dev** | `black-forest-labs/FLUX.1-dev` | Base | Cutting-edge quality |
| **SDXL Lightning** | `ByteDance/SDXL-Lightning` | Base | Fast inference (<1s) |

#### Pixel Art LoRAs

| LoRA | HuggingFace ID | Trigger | Notes |
|------|---------------|---------|-------|
| **Pixel Art XL** | `nerijs/pixel-art-xl` | (none) | Best SDXL pixel art LoRA; downscale 8x with nearest-neighbor |
| **PixelArtRedmond** | `artificialguybr/PixelArtRedmond` | "pixel art" | Ultimate pixel art LoRA |
| **Retro Pixel Flux** | `prithivMLmods/Retro-Pixel-Flux-LoRA` | "Retro Pixel" | Best for FLUX; retro game style |
| **Modern Pixel Art** | `UmeAiRT/FLUX.1-dev-LoRA-Modern_Pixel_art` | (none) | Modern 2D pixel art games |
| **SDXL Pixel Slider** | `ntc-ai/SDXL-LoRA-slider.pixel-art` | "pixel art" | Adjustable pixel art intensity |

#### RPG/Game Asset LoRAs

| LoRA | HuggingFace ID | Best For |
|------|---------------|----------|
| **Potion Art Engine** | `FFusion/FFusionXL-LoRa-SDXL-Potion-Art-Engine` | Fantasy RPG items |
| **Texture Synthesis** | `dog-god/texture-synthesis-sdxl-lora` | Seamless tileset textures |
| **DnD Model** | `Leiyan525/dnd-model-lora-en` | RPG/fantasy art |

### 2.2 Post-Processing Pipeline

1. Generate at 384x384 or 512x512 (SDXL native)
2. Apply pixel art LoRA during generation
3. **Downscale 8x with nearest-neighbor interpolation** for pixel-perfect output
4. Crop/resize to exact tileset dimensions
5. Validate PNG format, RGBA, even width

### 2.3 Provider Priority

1. **HuggingFace Inference API** (Primary) - Free tier, open-source models
2. **Google Gemini/Imagen-3** (Secondary) - Free tier: 100 images/day
3. **Local Stable Diffusion** (Fallback) - Automatic1111 or ComfyUI, unlimited
4. **Smart Auto-Select** - Automatically choose best available

---

## 3. Location Registry

26 total locations across 7 categories. All locations are extracted from the Crimson Eclipse GDD.

### 3.1 Hub Cities (3)

| Location ID | Name | Cultural Inspiration | Primary Theme |
|-------------|------|---------------------|---------------|
| `hub_vel_sahrad` | Vel Sahrad | London | Victorian Gothic, Urban Decay |
| `hub_val_duivra` | Val Duivra | France | Gothic Cathedral, Chess Motifs |
| `hub_skythenos` | Skythenos Cloud City | Greece | Ethereal Heights, Classical Ruins |

### 3.2 Act I: Font Dungeons (5)

| Location ID | Name | Element | Visual Motifs |
|-------------|------|---------|---------------|
| `font_garn_caladrun` | Garn Caladrun | Earth | Carved stone, root systems, crystal formations, Aztec glyphs |
| `font_khenenu_deep` | Khenenu Deep | Water | Flooded temples, bioluminescent flora, Egyptian architecture |
| `font_skyvaldr_cliffs` | Skyvaldr Cliffs | Air | Floating platforms, wind-carved stone, Greek elements |
| `font_volkheth_sarmaar` | Volkheth Sarmaar | Fire | Volcanic stone, lava rivers, brass mechanisms, Persian |
| `font_sanctum_hollow` | Sanctum of Hollow Winds | Harmony | Gothic cathedral, elemental fusion, stained glass |

### 3.3 Act II: Sin World Dungeons (7)

| Location ID | Name | Sin | Chakra |
|-------------|------|-----|--------|
| `sin_vault_gold` | Vault of Hollow Gold | Greed | Root |
| `sin_crimson_mirage` | Crimson Mirage Temple | Lust | Sacral |
| `sin_maw_bloom` | Maw of Endless Bloom | Gluttony | Solar Plexus |
| `sin_garden_withered` | Garden of Withered Light | Sloth | Heart |
| `sin_fortress_voices` | Fortress of Broken Voices | Wrath | Throat |
| `sin_mirror_sanctum` | Mirror Sanctum | Envy | Third Eye |
| `sin_ecliptic_throne` | The Ecliptic Throne | Pride | Crown |

### 3.4 Act III, Overworlds, Special (9)

| Location ID | Name | Category |
|-------------|------|----------|
| `rev_lachrymal_gate` | The Lachrymal Gate | Revelation |
| `rev_vordr_restoration` | The Vordr Restoration | Revelation |
| `region_xochzan` | Xoch'Zan Jungle | Overworld |
| `region_pelmara` | Pelmara Coast | Overworld |
| `region_skythenos` | Skythenos Region | Overworld |
| `region_imenthi` | Imenthi Reach | Overworld |
| `special_chess_demon` | Chess Demon Belcour | Special |
| `special_dreamwalking` | Dreamwalking Spaces | Special |
| `overworld_general` | Overworld General | General |
| `overworld_space` | Overworld Outer Space | General |

---

## 4. Prompt Library

All location prompts are sourced from the **Crimson Eclipse RPG Architect Prompt Library** (`Crimson_Eclipse_Architect_Library.pdf`). Each location has 4 sheet types: [T] Terrain, [W] Walls, [D] Decor, [S] Special. All 16 prompt sets are embedded in `lib/data/prompts/location_prompts.dart`.

---

## 5. Application Architecture

### 5.1 Technology Stack

- **Framework:** Flutter 3.44+
- **Language:** Dart 3.12+
- **State Management:** Provider package
- **HTTP:** http package
- **Image Processing:** image package (pure Dart)
- **AI Primary:** HuggingFace Inference API
- **AI Secondary:** Google Generative AI (google_generative_ai)
- **AI Fallback:** Local Stable Diffusion (Automatic1111/ComfyUI REST API)

### 5.2 Project Structure

```
lib/
├── main.dart                        # Entry point
├── app.dart                         # MaterialApp + theme
├── models/                          # Data models
├── data/                            # Static data + prompts
├── services/                        # Business logic
│   └── providers/                   # AI provider implementations
├── state/                           # ChangeNotifier state
├── theme/                           # Dark gothic theme
├── screens/                         # Full pages
└── widgets/                         # Reusable widgets
    ├── controls/                    # Sidebar controls
    ├── preview/                     # Preview panel
    └── export/                      # Export dialog
```

### 5.3 Theme

- **Background:** Deep navy (#1A1A2E)
- **Surface:** Dark blue-gray (#16213E)
- **Primary:** Dark crimson (#8B0000)
- **Accent:** Bright crimson (#E94560)
- **Text:** Light gray/white
- **Log:** Cyan/green monospace

---

## 6. iOS / TestFlight Deployment

### 6.1 Requirements
- macOS with Xcode 15+
- Apple Developer Account
- Flutter SDK 3.44+

### 6.2 Build Steps
```bash
flutter pub get
flutter build ipa
# Upload to App Store Connect via Xcode or Transporter
```

### 6.3 Configuration
- **Bundle ID:** `com.crimsoneclipse.tilesetgenerator`
- **App Name:** Crimson Eclipse Tileset Generator
- **Minimum iOS:** 16.0

---

## 7. Development Phases

### Phase 1: Foundation (Complete)
- Flutter project with macOS/iOS targets
- All data models and 26-location registry
- Prompt library (16 locations x 4 sheet types)
- Dark gothic UI theme
- Full screen layout with all controls

### Phase 2: AI Integration (Complete)
- HuggingFace, Google Gemini, Local SD providers
- Prompt builder pipeline
- Rate limiting and usage tracking

### Phase 3: Generation & Export (Complete)
- Full generation pipeline
- Post-processing (downscale, pixel-perfect)
- Format validation
- Export with naming convention

### Phase 4: Polish & Deploy
- iOS TestFlight deployment
- macOS App Store submission
- Performance optimization

---

## 8. Dependencies

```yaml
dependencies:
  provider: ^6.1.2
  http: ^1.2.2
  image: ^4.3.0
  file_picker: ^8.1.6
  path_provider: ^2.1.5
  shared_preferences: ^2.3.4
  google_generative_ai: ^0.4.6
  path: ^1.9.1
  intl: ^0.19.0
  collection: ^1.19.1
```

---

*Document Version: 2.0*
*Last Updated: June 2026*
*The Crimson Eclipse (c) 2025-2026*
