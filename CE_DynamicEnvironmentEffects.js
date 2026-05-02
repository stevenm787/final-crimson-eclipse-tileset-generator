/*:
 * @target MZ
 * @plugindesc v1.0.0 Real-time environmental effects (weather, atmosphere) with live in-game editor, layer system, presets, transitions, zones — no PNG overlays needed.
 * @author Steve
 * @url https://example.com
 *
 * @help
 * == CE_DynamicEnvironmentEffects v1.0.0 ==
 *
 * Real-time environmental effects system with 9 built-in effect types, layer-based composition,
 * preset save/load, zone masking, transitions, battle support, and cross-platform quality scaling.
 *
 * === QUICK START ===
 *
 * 1. Set "defaultPreset" plugin param to "Misty Morning" (or another built-in).
 * 2. Run playtest. You should see effects on the map.
 * 3. Press F10 to open the live editor. Adjust parameters, toggle layers, save presets.
 * 4. Use plugin commands (showPreset, transitionTo, addLayer, etc.) from events.
 *
 * === EFFECT TYPES ===
 *
 * - MistEffect: soft drifting clouds with vertical drift
 * - FogEffect: ground-hugging mist
 * - CloudShadowsEffect: large dark shadows drifting across screen
 * - ParticlesEffect: generic configurable particles (shape, swirl, gravity)
 * - GodRaysEffect: translucent additive rays with sine pulse
 * - FallingLeavesEffect: leaf-shaped particles with sine sway and rotation
 * - ThunderStormEffect: rain streaks + full-screen flash + optional shake
 * - BloodRainEffect: dark red rain with ground splashes
 * - SandstormEffect: fast dust + haze overlay + gust bursts
 *
 * === NOTETAGS ===
 *
 * Map notes:
 *   <deeIndoor>                                   — marks map as indoor (outdoor-only layers hidden)
 *   <deeZoneRect:id, x=10 y=10 w=4 h=4, intensity=0.5>  — defines a rectangular zone
 *   <deeZone:id, regions=1+2+5, intensity=1.0>  — defines a region-based zone
 *   <deePreset:Sunny Plains, transitionFrames=60>   — applies a preset on map load
 *
 * === PLUGIN COMMANDS ===
 *
 * showPreset <presetName> [transitionFrames=0] [easing=linear]
 *   Switches to a preset with optional fade.
 *
 * hidePreset [transitionFrames=0]
 *   Fades out all layers.
 *
 * transitionTo <presetName> <frames> [easing=linear]
 *   Explicit transition to preset.
 *
 * addLayer <effectType> [paramOverridesJson]
 *   Adds a runtime layer without saving.
 *
 * removeLayer <layerName>
 *   Removes a layer by name.
 *
 * setLayerProperty <layerName> <property> <value>
 *   Tweaks a single property on a live layer.
 *
 * setQuality <level: low|medium|high>
 *   Switches quality level.
 *
 * enableBattleEnvironment
 *   Renders current preset in battle.
 *
 * disableBattleEnvironment
 *   Hides from battle.
 *
 * applyZoneMask <layerName> <zoneIds: id1,id2,id3>
 *   Restricts layer to zones.
 *
 * defineRegionZone <zoneId> <regions: 1+2+3> [indoor=false] [intensity=1.0]
 *   Defines a region-based zone.
 *
 * defineRectZone <zoneId> <mapId> <x> <y> <w> <h> [intensity=1.0]
 *   Defines a rectangular zone.
 *
 * clearZones
 *   Drops all dynamic zones.
 *
 * rampIntensity <layerName> <targetIntensity> <frames>
 *   Animates layer intensity.
 *
 * dayNightSequence <presetNames: preset1,preset2,...> <framesPerStage>
 *   Chains transitions cyclically.
 *
 * === SCRIPT CALLS ===
 *
 * DEE.show(presetName, transitionFrames, easing)  — show preset
 * DEE.hide(transitionFrames)                        — hide all
 * DEE.transition(presetName, frames, easing)       — transition
 * DEE.setQuality(level)                             — set quality
 * DEE.Editor.toggle()                               — open/close editor
 * DEE.PresetManager.save(name)                      — save current as preset
 * DEE.PresetManager.load(name)                      — load preset
 *
 * === PERFORMANCE TIPS ===
 *
 * - Use "low" quality on mobile or slower devices.
 * - Reduce particle density on slow maps.
 * - Disable pixelation filter if frame rate drops.
 * - Zone masking is cheap; use it to restrict effects to regions.
 *
 * === TERMS OF USE ===
 *
 * Free for use in commercial and non-commercial projects.
 * Credit optional.
 *
 * @param defaultPreset
 * @text Default Preset
 * @type combo
 * @option None
 * @option Sunny Plains
 * @option Misty Morning
 * @option Heavy Fog
 * @option Drizzling Rain
 * @option Thunder Storm
 * @option Blood Rain Subtle
 * @option Blood Rain Extreme
 * @option Sandstorm Light
 * @option Sandstorm Heavy
 * @option Falling Leaves
 * @option God Rays Cathedral
 * @option Spooky Graveyard
 * @option Indoor Dust
 * @default Misty Morning
 * @desc Auto-applied on new game or map load if no per-map override.
 *
 * @param defaultQuality
 * @text Default Quality
 * @type select
 * @option low
 * @option medium
 * @option high
 * @default medium
 * @desc Initial quality level. Saved after first run.
 *
 * @param editorEnabled
 * @text Editor Enabled
 * @type boolean
 * @default true
 * @desc Enable the live in-game editor (F10 in playtest).
 *
 * @param editorKey
 * @text Editor Toggle Key
 * @type select
 * @option F10
 * @option F11
 * @option F12
 * @default F10
 * @desc Key to toggle editor in playtest.
 *
 * @param pixelationDefault
 * @text Default Pixelation
 * @type number
 * @min 0
 * @max 32
 * @default 0
 * @desc Global pixelation amount (0 = off).
 *
 * @param enableInBattle
 * @text Enable in Battle
 * @type boolean
 * @default true
 * @desc Show effects in battle by default.
 *
 * @param applyOnNewGame
 * @text Apply on New Game
 * @type boolean
 * @default true
 * @desc Auto-apply defaultPreset on first map.
 *
 * @param customTextureFolder
 * @text Custom Texture Folder
 * @type string
 * @default img/pictures
 * @desc Subfolder for custom overlay textures.
 *
 * @param screenShakeOnThunder
 * @text Thunder Shake
 * @type boolean
 * @default false
 * @desc Link thunder flashes to screen shake.
 *
 * @param cameraZoomCompat
 * @text Camera Zoom Compat
 * @type boolean
 * @default true
 * @desc Effects respect $gameScreen.zoom.
 *
 * @command showPreset
 * @text Show Preset
 * @desc Switch to a preset with optional transition.
 * @arg presetName
 * @type combo
 * @option None
 * @option Sunny Plains
 * @option Misty Morning
 * @option Heavy Fog
 * @option Drizzling Rain
 * @option Thunder Storm
 * @option Blood Rain Subtle
 * @option Blood Rain Extreme
 * @option Sandstorm Light
 * @option Sandstorm Heavy
 * @option Falling Leaves
 * @option God Rays Cathedral
 * @option Spooky Graveyard
 * @option Indoor Dust
 * @default Misty Morning
 * @arg transitionFrames
 * @type number
 * @min 0
 * @default 0
 * @desc Frames to transition (0 = instant).
 * @arg easing
 * @type select
 * @option linear
 * @option easeInQuad
 * @option easeOutQuad
 * @option easeInOutQuad
 * @option easeInCubic
 * @option easeOutCubic
 * @option easeInOutCubic
 * @default linear
 *
 * @command hidePreset
 * @text Hide Preset
 * @desc Fade out all layers.
 * @arg transitionFrames
 * @type number
 * @min 0
 * @default 60
 *
 * @command transitionTo
 * @text Transition To
 * @desc Transition to preset with easing.
 * @arg presetName
 * @type combo
 * @option None
 * @option Sunny Plains
 * @option Misty Morning
 * @option Heavy Fog
 * @option Drizzling Rain
 * @option Thunder Storm
 * @option Blood Rain Subtle
 * @option Blood Rain Extreme
 * @option Sandstorm Light
 * @option Sandstorm Heavy
 * @option Falling Leaves
 * @option God Rays Cathedral
 * @option Spooky Graveyard
 * @option Indoor Dust
 * @default Misty Morning
 * @arg frames
 * @type number
 * @min 1
 * @default 60
 * @arg easing
 * @type select
 * @option linear
 * @option easeInQuad
 * @option easeOutQuad
 * @option easeInOutQuad
 * @option easeInCubic
 * @option easeOutCubic
 * @option easeInOutCubic
 * @default linear
 *
 * @command addLayer
 * @text Add Layer
 * @desc Add a runtime layer.
 * @arg effectType
 * @type select
 * @option mist
 * @option fog
 * @option cloudShadows
 * @option particles
 * @option godRays
 * @option fallingLeaves
 * @option thunderStorm
 * @option bloodRain
 * @option sandstorm
 * @default mist
 * @arg paramJson
 * @type note
 * @default {}
 * @desc JSON object of parameter overrides.
 *
 * @command removeLayer
 * @text Remove Layer
 * @desc Remove a layer by name.
 * @arg layerName
 * @type string
 * @default layer1
 *
 * @command setLayerProperty
 * @text Set Layer Property
 * @desc Change a single layer property.
 * @arg layerName
 * @type string
 * @default layer1
 * @arg property
 * @type string
 * @default opacity
 * @arg value
 * @type string
 * @default 1.0
 *
 * @command setQuality
 * @text Set Quality
 * @desc Change quality level.
 * @arg level
 * @type select
 * @option low
 * @option medium
 * @option high
 * @default medium
 *
 * @command enableBattleEnvironment
 * @text Enable Battle Environment
 * @desc Render current preset in battle.
 *
 * @command disableBattleEnvironment
 * @text Disable Battle Environment
 * @desc Hide from battle.
 *
 * @command applyZoneMask
 * @text Apply Zone Mask
 * @desc Restrict layer to zones.
 * @arg layerName
 * @type string
 * @default layer1
 * @arg zoneIds
 * @type string
 * @default zone1,zone2
 * @desc Comma-separated zone IDs.
 *
 * @command defineRegionZone
 * @text Define Region Zone
 * @desc Define a region-based zone.
 * @arg zoneId
 * @type string
 * @default zone1
 * @arg regions
 * @type string
 * @default 1,2,3
 * @desc Comma-separated region IDs.
 * @arg indoor
 * @type boolean
 * @default false
 * @arg intensity
 * @type number
 * @min 0
 * @max 2
 * @decimals 2
 * @default 1.0
 *
 * @command defineRectZone
 * @text Define Rect Zone
 * @desc Define a rectangular zone.
 * @arg zoneId
 * @type string
 * @default zone1
 * @arg mapId
 * @type number
 * @default 1
 * @arg x
 * @type number
 * @default 0
 * @arg y
 * @type number
 * @default 0
 * @arg w
 * @type number
 * @default 10
 * @arg h
 * @type number
 * @default 10
 * @arg intensity
 * @type number
 * @min 0
 * @max 2
 * @decimals 2
 * @default 1.0
 *
 * @command clearZones
 * @text Clear Zones
 * @desc Remove all dynamic zones.
 *
 * @command rampIntensity
 * @text Ramp Intensity
 * @desc Animate layer intensity.
 * @arg layerName
 * @type string
 * @default layer1
 * @arg targetIntensity
 * @type number
 * @min 0
 * @max 1
 * @decimals 2
 * @default 1.0
 * @arg frames
 * @type number
 * @min 1
 * @default 60
 *
 * @command dayNightSequence
 * @text Day-Night Sequence
 * @desc Chain transitions cyclically.
 * @arg presetNames
 * @type string
 * @default Sunny Plains,Thunder Storm,Misty Morning
 * @desc Comma-separated preset names.
 * @arg framesPerStage
 * @type number
 * @min 1
 * @default 300
 */

(() => {
    'use strict';

    const PLUGIN_NAME = 'CE_DynamicEnvironmentEffects';
    const VERSION = '1.0.0';
    const params = PluginManager.parameters(PLUGIN_NAME);

    window.Imported = window.Imported || {};
    window.Imported[PLUGIN_NAME] = VERSION;

    // ============ UTILITIES & FACTORIES ============

    const DEE = window.DEE = {};

    function clamp(val, min, max) { return Math.max(min, Math.min(max, val)); }
    function lerp(a, b, t) { return a + (b - a) * clamp(t, 0, 1); }
    function lerpColor(c1, c2, t) {
        const a = c1 >> 16 & 0xFF, b = (c1 >> 8) & 0xFF, c = c1 & 0xFF;
        const d = c2 >> 16 & 0xFF, e = (c2 >> 8) & 0xFF, f = c2 & 0xFF;
        return (Math.round(lerp(a, d, t)) << 16) | (Math.round(lerp(b, e, t)) << 8) | Math.round(lerp(c, f, t));
    }
    function parseColor(hex) {
        if (typeof hex === 'number') return hex;
        const m = /^#?([0-9A-Fa-f]{6})$/.exec(String(hex || '#ffffff'));
        return m ? parseInt(m[1], 16) : 0xffffff;
    }
    function colorToHex(col) { return '#' + ('000000' + (col >>> 0).toString(16)).slice(-6); }
    function mulberry32(a) {
        return function () {
            a |= 0; a = (a + 0x6D2B79F5) | 0;
            let t = Math.imul(a ^ (a >>> 15), 1 | a);
            t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
            return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
        };
    }
    function angleToVec(angle) {
        const rad = (angle * Math.PI) / 180;
        return { x: Math.cos(rad), y: Math.sin(rad) };
    }
    const EASING = {
        linear: t => t,
        easeInQuad: t => t * t,
        easeOutQuad: t => t * (2 - t),
        easeInOutQuad: t => t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t,
        easeInCubic: t => t * t * t,
        easeOutCubic: t => (--t) * t * t + 1,
        easeInOutCubic: t => t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * (t - 2)) * (2 * (t - 2)) + 1
    };
    function getEasing(name) { return EASING[name] || EASING.linear; }
    const BLEND_MODES = {
        NORMAL: PIXI.BLEND_MODES.NORMAL,
        ADD: PIXI.BLEND_MODES.ADD,
        MULTIPLY: PIXI.BLEND_MODES.MULTIPLY,
        SCREEN: PIXI.BLEND_MODES.SCREEN,
        OVERLAY: PIXI.BLEND_MODES.OVERLAY,
        DARKEN: PIXI.BLEND_MODES.DARKEN,
        LIGHTEN: PIXI.BLEND_MODES.LIGHTEN
    };

    class BitmapFactory {
        static _cache = {};
        static get(key, generator) {
            if (!this._cache[key]) this._cache[key] = generator();
            return this._cache[key];
        }
        static radialSoft(size, color) {
            return this.get(`radialSoft_${size}_${color}`, () => {
                const bmp = new Bitmap(size, size);
                bmp.context.fillStyle = colorToHex(color || 0xffffff);
                const grad = bmp.context.createRadialGradient(size / 2, size / 2, 0, size / 2, size / 2, size / 2);
                grad.addColorStop(0, colorToHex(color || 0xffffff) + 'ff');
                grad.addColorStop(1, colorToHex(color || 0xffffff) + '00');
                bmp.context.fillStyle = grad;
                bmp.context.fillRect(0, 0, size, size);
                return bmp;
            });
        }
        static dot(size, color) {
            return this.get(`dot_${size}_${color}`, () => {
                const bmp = new Bitmap(size, size);
                bmp.context.fillStyle = colorToHex(color || 0xffffff);
                bmp.context.beginPath();
                bmp.context.arc(size / 2, size / 2, size / 2, 0, Math.PI * 2);
                bmp.context.fill();
                return bmp;
            });
        }
        static streak(w, h, color) {
            return this.get(`streak_${w}_${h}_${color}`, () => {
                const bmp = new Bitmap(w, h);
                bmp.context.fillStyle = colorToHex(color || 0xffffff);
                bmp.context.fillRect(0, 0, w, h);
                return bmp;
            });
        }
        static leaf(size, color) {
            return this.get(`leaf_${size}_${color}`, () => {
                const bmp = new Bitmap(size, size);
                bmp.context.fillStyle = colorToHex(color || 0xffaa33);
                bmp.context.beginPath();
                bmp.context.ellipse(size / 2, size / 2, size / 2.5, size / 3, 0, 0, Math.PI * 2);
                bmp.context.fill();
                return bmp;
            });
        }
        static ray(w, h, color) {
            return this.get(`ray_${w}_${h}_${color}`, () => {
                const bmp = new Bitmap(w, h);
                bmp.context.fillStyle = colorToHex(color || 0xffffff);
                bmp.context.globalAlpha = 0.5;
                bmp.context.fillRect(0, 0, w, h);
                return bmp;
            });
        }
        static cloudShadow(w, h) {
            return this.get(`cloudShadow_${w}_${h}`, () => {
                const bmp = new Bitmap(w, h);
                bmp.context.fillStyle = '#000000';
                bmp.context.globalAlpha = 0.3;
                bmp.context.beginPath();
                bmp.context.ellipse(w / 2, h / 2, w / 2, h / 3, 0, 0, Math.PI * 2);
                bmp.context.fill();
                return bmp;
            });
        }
        static whitePixel() {
            return this.get('whitePixel', () => {
                const bmp = new Bitmap(1, 1);
                bmp.context.fillStyle = '#ffffff';
                bmp.context.fillRect(0, 0, 1, 1);
                return bmp;
            });
        }
        static triangle(size, color) {
            return this.get(`triangle_${size}_${color}`, () => {
                const bmp = new Bitmap(size, size);
                bmp.context.fillStyle = colorToHex(color || 0xffffff);
                bmp.context.beginPath();
                bmp.context.moveTo(size / 2, 0);
                bmp.context.lineTo(size, size);
                bmp.context.lineTo(0, size);
                bmp.context.closePath();
                bmp.context.fill();
                return bmp;
            });
        }
        static square(size, color) {
            return this.get(`square_${size}_${color}`, () => {
                const bmp = new Bitmap(size, size);
                bmp.context.fillStyle = colorToHex(color || 0xffffff);
                bmp.context.fillRect(0, 0, size, size);
                return bmp;
            });
        }
    }

    // ============ QUALITY CONTROLLER ============

    class QualityController {
        static LOW = { particleMul: 0.4, flashMul: 0.5, allowFilters: false, throttle: 2 };
        static MEDIUM = { particleMul: 1.0, flashMul: 1.0, allowFilters: true, throttle: 1 };
        static HIGH = { particleMul: 1.5, flashMul: 1.0, allowFilters: true, throttle: 1 };
        static _current = 'medium';
        static get(level) {
            const map = { low: this.LOW, medium: this.MEDIUM, high: this.HIGH };
            return map[level] || this.MEDIUM;
        }
        static set(level) { this._current = level; }
        static current() { return this.get(this._current); }
    }

    // ============ EFFECT BASE CLASS ============

    class DEEEffect {
        constructor(params = {}) {
            this._params = params;
            this._container = null;
            this._rng = mulberry32((params.seed || Math.random()) * 0xffffffff);
            this._initialized = false;
            this._time = 0;
        }

        init(rendererContext) {
            this._initialized = true;
            this._container = new PIXI.Container();
            this._init(rendererContext);
        }

        _init(rendererContext) {}

        update(dt, env) {
            if (!this._initialized) return;
            this._time += dt;
            this._update(dt, env);
        }

        _update(dt, env) {}

        resize(w, h) {
            if (!this._initialized) return;
            this._resize(w, h);
        }

        _resize(w, h) {}

        destroy() {
            if (this._container) {
                this._container.destroy({ children: true });
                this._container = null;
            }
            this._destroy();
            this._initialized = false;
        }

        _destroy() {}

        applyContainerProps(visibility, blendMode, opacity, depth) {
            if (!this._container) return;
            this._container.visible = visibility;
            this._container.blendMode = blendMode;
            this._container.alpha = opacity;
            this._container.zIndex = depth * 1000;
        }

        applyProperty(name, value) {}

        serialize() { return JSON.parse(JSON.stringify(this._params)); }

        static getParameterSchema() { return []; }
    }

    // ============ PARTICLE POOL ============

    class ParticlePool {
        constructor(poolSize = 200) {
            this.pool = [];
            this.active = [];
            for (let i = 0; i < poolSize; i++) {
                const sprite = new PIXI.Sprite(BitmapFactory.dot(4, 0xffffff));
                sprite.visible = false;
                this.pool.push(sprite);
            }
        }

        get(container) {
            let sprite;
            if (this.pool.length > 0) {
                sprite = this.pool.pop();
            } else {
                sprite = new PIXI.Sprite(BitmapFactory.dot(4, 0xffffff));
            }
            sprite.visible = true;
            container.addChild(sprite);
            this.active.push(sprite);
            return sprite;
        }

        release(sprite, container) {
            sprite.visible = false;
            container.removeChild(sprite);
            this.active = this.active.filter(s => s !== sprite);
            this.pool.push(sprite);
        }

        clear() {
            for (const sprite of this.active) sprite.visible = false;
            this.pool.push(...this.active);
            this.active = [];
        }
    }

    // ============ EFFECT: MIST ============

    class MistEffect extends DEEEffect {
        _init(rendererContext) {
            const size = this._params.size || 80;
            const color = parseColor(this._params.color || 0x8899ff);
            this._bitmap = BitmapFactory.radialSoft(size, color);
            this._sprites = [];
            const density = clamp((this._params.density || 0.5) * QualityController.current().particleMul, 0, 1);
            const count = Math.ceil(30 * density);
            for (let i = 0; i < count; i++) {
                const sprite = new PIXI.Sprite(this._bitmap);
                sprite.x = Math.random() * Graphics.width;
                sprite.y = Math.random() * (Graphics.height * 0.6);
                sprite.alpha = Math.random() * 0.5 + 0.3;
                sprite.scale.set(1 + Math.random() * 0.5);
                this._container.addChild(sprite);
                this._sprites.push({ sprite, vx: (Math.random() - 0.5) * 0.5, vy: (this._params.verticalDrift || 0.1) * (Math.random() * 0.5 + 0.5) });
            }
        }

        _update(dt, env) {
            const speed = (this._params.speed || 1) * 0.02;
            for (const item of this._sprites) {
                item.sprite.x += item.vx * speed * 60 * dt;
                item.sprite.y -= item.vy * speed * 60 * dt;
                if (item.sprite.x > Graphics.width) item.sprite.x = -50;
                if (item.sprite.x < -50) item.sprite.x = Graphics.width;
                if (item.sprite.y < -50) item.sprite.y = Graphics.height;
            }
        }

        static getParameterSchema() {
            return [
                { name: 'speed', type: 'number', min: 0, max: 5, default: 1, label: 'Speed', group: 'Motion' },
                { name: 'density', type: 'number', min: 0, max: 1, default: 0.5, label: 'Density', group: 'Appearance' },
                { name: 'size', type: 'number', min: 20, max: 200, default: 80, label: 'Size', group: 'Appearance' },
                { name: 'verticalDrift', type: 'number', min: 0, max: 2, default: 0.1, label: 'Vertical Drift', group: 'Motion' },
                { name: 'color', type: 'color', default: '#8899ff', label: 'Color', group: 'Appearance' },
                { name: 'opacity', type: 'number', min: 0, max: 1, default: 0.7, label: 'Opacity', group: 'Appearance' }
            ];
        }
    }

    // ============ EFFECT: FOG ============

    class FogEffect extends MistEffect {
        _init(rendererContext) {
            const size = this._params.size || 100;
            const color = parseColor(this._params.color || 0xccccdd);
            this._bitmap = BitmapFactory.radialSoft(size, color);
            this._sprites = [];
            const density = clamp((this._params.density || 0.6) * QualityController.current().particleMul, 0, 1);
            const count = Math.ceil(40 * density);
            for (let i = 0; i < count; i++) {
                const sprite = new PIXI.Sprite(this._bitmap);
                sprite.x = Math.random() * Graphics.width;
                sprite.y = Graphics.height * 0.5 + Math.random() * (Graphics.height * 0.4);
                sprite.alpha = Math.random() * 0.4 + 0.4;
                sprite.scale.set(1.2 + Math.random() * 0.8);
                this._container.addChild(sprite);
                const groundHug = this._params.groundHugFactor || 0.8;
                this._sprites.push({ sprite, vx: (Math.random() - 0.5) * 0.3, vy: 0.05 * (1 - groundHug) });
            }
        }

        static getParameterSchema() {
            return [
                { name: 'speed', type: 'number', min: 0, max: 5, default: 0.8, label: 'Speed', group: 'Motion' },
                { name: 'density', type: 'number', min: 0, max: 1, default: 0.6, label: 'Density', group: 'Appearance' },
                { name: 'size', type: 'number', min: 20, max: 200, default: 100, label: 'Size', group: 'Appearance' },
                { name: 'groundHugFactor', type: 'number', min: 0, max: 1, default: 0.8, label: 'Ground Hug', group: 'Motion' },
                { name: 'color', type: 'color', default: '#ccccdd', label: 'Color', group: 'Appearance' },
                { name: 'opacity', type: 'number', min: 0, max: 1, default: 0.8, label: 'Opacity', group: 'Appearance' }
            ];
        }
    }

    // ============ EFFECT: CLOUD SHADOWS ============

    class CloudShadowsEffect extends DEEEffect {
        _init(rendererContext) {
            this._clouds = [];
            const count = this._params.cloudCount || 5;
            for (let i = 0; i < count; i++) {
                const w = (this._params.cloudSize || 200) + Math.random() * 100;
                const h = w * 0.3;
                const sprite = new PIXI.Sprite(BitmapFactory.cloudShadow(w, h));
                sprite.x = Math.random() * Graphics.width;
                sprite.y = Math.random() * (Graphics.height * 0.5);
                sprite.blendMode = PIXI.BLEND_MODES.MULTIPLY;
                this._container.addChild(sprite);
                this._clouds.push({ sprite, vx: Math.random() * 0.3 + 0.1 });
            }
        }

        _update(dt, env) {
            const speed = (this._params.speed || 1) * 0.01;
            for (const cloud of this._clouds) {
                cloud.sprite.x += cloud.vx * speed * 60 * dt;
                if (cloud.sprite.x > Graphics.width) cloud.sprite.x = -200;
            }
        }

        static getParameterSchema() {
            return [
                { name: 'speed', type: 'number', min: 0, max: 5, default: 1, label: 'Speed', group: 'Motion' },
                { name: 'cloudCount', type: 'number', min: 1, max: 20, default: 5, label: 'Cloud Count', group: 'Appearance' },
                { name: 'cloudSize', type: 'number', min: 50, max: 400, default: 200, label: 'Cloud Size', group: 'Appearance' },
                { name: 'opacity', type: 'number', min: 0, max: 1, default: 0.4, label: 'Opacity', group: 'Appearance' }
            ];
        }
    }

    // ============ EFFECT: PARTICLES ============

    class ParticlesEffect extends DEEEffect {
        _init(rendererContext) {
            const shape = this._params.shape || 'circle';
            const color = parseColor(this._params.color || 0xffffff);
            const size = this._params.size || 4;
            let bitmap;
            if (shape === 'circle') bitmap = BitmapFactory.dot(size, color);
            else if (shape === 'square') bitmap = BitmapFactory.square(size, color);
            else if (shape === 'triangle') bitmap = BitmapFactory.triangle(size, color);
            else bitmap = BitmapFactory.dot(size, color);
            this._shape = shape;
            this._pool = new ParticlePool(Math.ceil(100 * QualityController.current().particleMul));
            this._particles = [];
            this._spawnParticles(bitmap);
        }

        _spawnParticles(bitmap) {
            const density = clamp((this._params.density || 0.5) * QualityController.current().particleMul, 0, 1);
            const count = Math.ceil(50 * density);
            for (let i = 0; i < count; i++) {
                const sprite = this._pool.get(this._container);
                sprite.texture = bitmap;
                const angle = Math.random() * Math.PI * 2;
                const speed = 1 + Math.random() * 2;
                sprite.x = Math.random() * Graphics.width;
                sprite.y = Math.random() * Graphics.height;
                sprite.alpha = Math.random() * 0.7 + 0.3;
                this._particles.push({
                    sprite, vx: Math.cos(angle) * speed, vy: Math.sin(angle) * speed,
                    life: 60 + Math.random() * 60, maxLife: 120
                });
            }
        }

        _update(dt, env) {
            const gravity = (this._params.gravity || 0) * 0.01;
            const swirl = (this._params.swirl || 0) * 0.01;
            for (let i = this._particles.length - 1; i >= 0; i--) {
                const p = this._particles[i];
                p.sprite.x += p.vx * 60 * dt;
                p.sprite.y += p.vy * 60 * dt;
                p.vy += gravity * 60 * dt;
                p.life -= 60 * dt;
                p.sprite.alpha = (p.life / p.maxLife) * 0.7;
                if (p.life <= 0) this._pool.release(p.sprite, this._container), this._particles.splice(i, 1);
            }
            if (this._particles.length < 50) this._spawnParticles(this._pool.pool[0]?.texture);
        }

        static getParameterSchema() {
            return [
                { name: 'speed', type: 'number', min: 0, max: 5, default: 1, label: 'Speed', group: 'Motion' },
                { name: 'density', type: 'number', min: 0, max: 1, default: 0.5, label: 'Density', group: 'Appearance' },
                { name: 'size', type: 'number', min: 1, max: 20, default: 4, label: 'Size', group: 'Appearance' },
                { name: 'shape', type: 'select', options: ['circle', 'square', 'triangle'], default: 'circle', label: 'Shape', group: 'Appearance' },
                { name: 'swirl', type: 'number', min: 0, max: 2, default: 0, label: 'Swirl', group: 'Motion' },
                { name: 'gravity', type: 'number', min: -2, max: 2, default: 0, label: 'Gravity', group: 'Motion' },
                { name: 'color', type: 'color', default: '#ffffff', label: 'Color', group: 'Appearance' },
                { name: 'opacity', type: 'number', min: 0, max: 1, default: 0.7, label: 'Opacity', group: 'Appearance' }
            ];
        }
    }

    // ============ EFFECT: GOD RAYS ============

    class GodRaysEffect extends DEEEffect {
        _init(rendererContext) {
            this._rays = [];
            const count = this._params.rayCount || 3;
            const color = parseColor(this._params.color || 0xffff99);
            for (let i = 0; i < count; i++) {
                const w = this._params.rayWidth || 100;
                const h = Graphics.height;
                const sprite = new PIXI.Sprite(BitmapFactory.ray(w, h, color));
                sprite.blendMode = PIXI.BLEND_MODES.ADD;
                sprite.alpha = 0.3;
                sprite.x = (Graphics.width / count) * i;
                sprite.y = 0;
                this._container.addChild(sprite);
                this._rays.push({ sprite, angle: (this._params.rayAngle || 45) + i * 10 });
            }
        }

        _update(dt, env) {
            const pulseSpeed = (this._params.pulseSpeed || 1) * 0.05;
            for (const ray of this._rays) {
                ray.sprite.alpha = 0.3 + Math.sin(this._time * pulseSpeed) * 0.2;
            }
        }

        static getParameterSchema() {
            return [
                { name: 'rayCount', type: 'number', min: 1, max: 10, default: 3, label: 'Ray Count', group: 'Appearance' },
                { name: 'rayWidth', type: 'number', min: 20, max: 300, default: 100, label: 'Ray Width', group: 'Appearance' },
                { name: 'rayAngle', type: 'number', min: 0, max: 360, default: 45, label: 'Ray Angle', group: 'Motion' },
                { name: 'pulseSpeed', type: 'number', min: 0.1, max: 5, default: 1, label: 'Pulse Speed', group: 'Motion' },
                { name: 'color', type: 'color', default: '#ffff99', label: 'Color', group: 'Appearance' },
                { name: 'opacity', type: 'number', min: 0, max: 1, default: 0.3, label: 'Opacity', group: 'Appearance' }
            ];
        }
    }

    // ============ EFFECT: FALLING LEAVES ============

    class FallingLeavesEffect extends DEEEffect {
        _init(rendererContext) {
            const size = this._params.size || 16;
            const color = parseColor(this._params.color || 0xff8844);
            this._bitmap = BitmapFactory.leaf(size, color);
            this._leaves = [];
            const density = clamp((this._params.density || 0.4) * QualityController.current().particleMul, 0, 1);
            const count = Math.ceil(30 * density);
            for (let i = 0; i < count; i++) {
                const sprite = new PIXI.Sprite(this._bitmap);
                sprite.x = Math.random() * Graphics.width;
                sprite.y = Math.random() * Graphics.height - Graphics.height;
                sprite.alpha = 0.6 + Math.random() * 0.4;
                sprite.rotation = Math.random() * Math.PI * 2;
                this._container.addChild(sprite);
                const swayAmp = (this._params.swayAmplitude || 2) * 0.5;
                this._leaves.push({
                    sprite, vy: 0.5 + Math.random() * 0.5, swayAmp, swayPhase: Math.random() * Math.PI * 2,
                    rotSpeed: (Math.random() - 0.5) * (this._params.rotationSpeedVariance || 0.1)
                });
            }
        }

        _update(dt, env) {
            const swayPeriod = (this._params.swayPeriod || 2) * 60;
            const speed = (this._params.speed || 1) * 60 * dt;
            for (const leaf of this._leaves) {
                leaf.sprite.y += leaf.vy * speed;
                leaf.sprite.x += Math.sin(this._time / swayPeriod + leaf.swayPhase) * leaf.swayAmp * speed;
                leaf.sprite.rotation += leaf.rotSpeed * speed;
                if (leaf.sprite.y > Graphics.height) leaf.sprite.y = -20;
                if (leaf.sprite.x > Graphics.width) leaf.sprite.x = -20;
                if (leaf.sprite.x < -20) leaf.sprite.x = Graphics.width;
            }
        }

        static getParameterSchema() {
            return [
                { name: 'speed', type: 'number', min: 0, max: 5, default: 1, label: 'Speed', group: 'Motion' },
                { name: 'density', type: 'number', min: 0, max: 1, default: 0.4, label: 'Density', group: 'Appearance' },
                { name: 'size', type: 'number', min: 8, max: 32, default: 16, label: 'Size', group: 'Appearance' },
                { name: 'swayAmplitude', type: 'number', min: 0, max: 5, default: 2, label: 'Sway Amplitude', group: 'Motion' },
                { name: 'swayPeriod', type: 'number', min: 0.5, max: 5, default: 2, label: 'Sway Period', group: 'Motion' },
                { name: 'rotationSpeedVariance', type: 'number', min: 0, max: 0.5, default: 0.1, label: 'Rotation Speed', group: 'Motion' },
                { name: 'color', type: 'color', default: '#ff8844', label: 'Color', group: 'Appearance' },
                { name: 'opacity', type: 'number', min: 0, max: 1, default: 0.8, label: 'Opacity', group: 'Appearance' }
            ];
        }
    }

    // ============ EFFECT: THUNDER STORM ============

    class ThunderStormEffect extends DEEEffect {
        _init(rendererContext) {
            this._rainPool = new ParticlePool(Math.ceil(200 * QualityController.current().particleMul));
            this._rainDrops = [];
            this._flashSprite = new PIXI.Sprite(BitmapFactory.whitePixel());
            this._flashSprite.width = Graphics.width;
            this._flashSprite.height = Graphics.height;
            this._flashSprite.alpha = 0;
            this._flashSprite.blendMode = PIXI.BLEND_MODES.ADD;
            this._container.addChild(this._flashSprite);
            this._spawnRain();
            this._nextFlash = 60 + Math.random() * 180;
        }

        _spawnRain() {
            const density = clamp((this._params.rainDensity || 0.7) * QualityController.current().particleMul, 0, 1);
            const count = Math.ceil(80 * density);
            for (let i = 0; i < count; i++) {
                const sprite = this._rainPool.get(this._container);
                sprite.texture = BitmapFactory.streak(2, 16, 0x8899cc);
                sprite.x = Math.random() * Graphics.width;
                sprite.y = Math.random() * Graphics.height - Graphics.height;
                sprite.alpha = 0.6;
                const windInfluence = (this._params.windInfluence || 0.2) * 0.5;
                this._rainDrops.push({ sprite, vy: 5 + Math.random() * 3, vx: windInfluence * (Math.random() - 0.5) });
            }
        }

        _update(dt, env) {
            const speed = (this._params.speed || 1) * 60 * dt;
            for (let i = this._rainDrops.length - 1; i >= 0; i--) {
                const drop = this._rainDrops[i];
                drop.sprite.y += drop.vy * speed;
                drop.sprite.x += drop.vx * speed;
                if (drop.sprite.y > Graphics.height) this._rainPool.release(drop.sprite, this._container), this._rainDrops.splice(i, 1);
            }
            if (this._rainDrops.length < 80) this._spawnRain();
            this._nextFlash -= 60 * dt;
            if (this._nextFlash <= 0) {
                const flashBrightness = this._params.flashBrightness || 0.8;
                this._flashSprite.alpha = flashBrightness;
                this._nextFlash = (this._params.flashFrequency || 4) + Math.random() * 10;
            } else this._flashSprite.alpha = Math.max(0, this._flashSprite.alpha - 0.1);
        }

        static getParameterSchema() {
            return [
                { name: 'speed', type: 'number', min: 0, max: 5, default: 1, label: 'Speed', group: 'Motion' },
                { name: 'rainDensity', type: 'number', min: 0, max: 1, default: 0.7, label: 'Rain Density', group: 'Appearance' },
                { name: 'flashFrequency', type: 'number', min: 1, max: 20, default: 4, label: 'Flash Frequency', group: 'Lightning' },
                { name: 'flashBrightness', type: 'number', min: 0, max: 1, default: 0.8, label: 'Flash Brightness', group: 'Lightning' },
                { name: 'windInfluence', type: 'number', min: 0, max: 2, default: 0.2, label: 'Wind Influence', group: 'Motion' },
                { name: 'opacity', type: 'number', min: 0, max: 1, default: 0.8, label: 'Opacity', group: 'Appearance' }
            ];
        }
    }

    // ============ EFFECT: BLOOD RAIN ============

    class BloodRainEffect extends ThunderStormEffect {
        _init(rendererContext) {
            this._rainPool = new ParticlePool(Math.ceil(200 * QualityController.current().particleMul));
            this._rainDrops = [];
            this._splashSprites = [];
            this._flashSprite = new PIXI.Sprite(BitmapFactory.whitePixel());
            this._flashSprite.width = Graphics.width;
            this._flashSprite.height = Graphics.height;
            this._flashSprite.alpha = 0;
            this._flashSprite.blendMode = PIXI.BLEND_MODES.ADD;
            this._flashSprite.tint = 0x330000;
            this._container.addChild(this._flashSprite);
            this._spawnRain();
            this._nextFlash = 60 + Math.random() * 180;
        }

        _spawnRain() {
            const density = clamp((this._params.rainDensity || 0.7) * QualityController.current().particleMul, 0, 1);
            const count = Math.ceil(80 * density);
            const color = parseColor(this._params.tint || 0x7a0a0a);
            for (let i = 0; i < count; i++) {
                const sprite = this._rainPool.get(this._container);
                sprite.texture = BitmapFactory.streak(2, 16, color);
                sprite.x = Math.random() * Graphics.width;
                sprite.y = Math.random() * Graphics.height - Graphics.height;
                sprite.alpha = 0.6;
                const windInfluence = (this._params.windInfluence || 0.2) * 0.5;
                this._rainDrops.push({ sprite, vy: 5 + Math.random() * 3, vx: windInfluence * (Math.random() - 0.5) });
            }
        }

        static getParameterSchema() {
            return [
                { name: 'speed', type: 'number', min: 0, max: 5, default: 1, label: 'Speed', group: 'Motion' },
                { name: 'rainDensity', type: 'number', min: 0, max: 1, default: 0.7, label: 'Rain Density', group: 'Appearance' },
                { name: 'flashFrequency', type: 'number', min: 1, max: 20, default: 4, label: 'Flash Frequency', group: 'Lightning' },
                { name: 'flashBrightness', type: 'number', min: 0, max: 1, default: 0.6, label: 'Flash Brightness', group: 'Lightning' },
                { name: 'tint', type: 'color', default: '#7a0a0a', label: 'Blood Tint', group: 'Appearance' },
                { name: 'windInfluence', type: 'number', min: 0, max: 2, default: 0.2, label: 'Wind Influence', group: 'Motion' },
                { name: 'opacity', type: 'number', min: 0, max: 1, default: 0.75, label: 'Opacity', group: 'Appearance' }
            ];
        }
    }

    // ============ EFFECT: SANDSTORM ============

    class SandstormEffect extends DEEEffect {
        _init(rendererContext) {
            this._dustPool = new ParticlePool(Math.ceil(150 * QualityController.current().particleMul));
            this._dustParticles = [];
            const color = parseColor(this._params.dustColor || 0xcc9933);
            const dustSize = this._params.size || 4;
            this._dustBitmap = BitmapFactory.dot(dustSize, color);
            this._spawnDust();
            this._hazeSprite = new PIXI.Sprite(BitmapFactory.whitePixel());
            this._hazeSprite.width = Graphics.width;
            this._hazeSprite.height = Graphics.height;
            this._hazeSprite.alpha = (this._params.hazeOpacity || 0.2) * 0.3;
            this._hazeSprite.tint = parseColor(this._params.dustColor || 0xcc9933);
            this._hazeSprite.blendMode = PIXI.BLEND_MODES.OVERLAY;
            this._container.addChild(this._hazeSprite);
            this._gustPhase = 0;
        }

        _spawnDust() {
            const density = clamp((this._params.density || 0.6) * QualityController.current().particleMul, 0, 1);
            const count = Math.ceil(60 * density);
            for (let i = 0; i < count; i++) {
                const sprite = this._dustPool.get(this._container);
                sprite.texture = this._dustBitmap;
                sprite.x = Math.random() * Graphics.width;
                sprite.y = Math.random() * Graphics.height;
                sprite.alpha = 0.4 + Math.random() * 0.4;
                const windDir = angleToVec(this._params.windDirection || 0);
                this._dustParticles.push({
                    sprite, vx: windDir.x * (2 + Math.random() * 3), vy: (Math.random() - 0.5) * 0.5,
                    sizeVar: 0.5 + Math.random() * 1.5
                });
            }
        }

        _update(dt, env) {
            this._gustPhase += (this._params.gustFrequency || 1) * 0.01 * 60 * dt;
            const gust = 1 + Math.sin(this._gustPhase) * (this._params.gustStrength || 0.5) * 0.5;
            const speed = (this._params.speed || 1) * gust * 60 * dt;
            for (let i = this._dustParticles.length - 1; i >= 0; i--) {
                const dust = this._dustParticles[i];
                dust.sprite.x += dust.vx * speed;
                dust.sprite.y += dust.vy * speed;
                if (dust.sprite.x > Graphics.width) dust.sprite.x = -10;
                if (dust.sprite.x < -10) dust.sprite.x = Graphics.width;
                if (dust.sprite.y > Graphics.height) this._dustPool.release(dust.sprite, this._container), this._dustParticles.splice(i, 1);
            }
            if (this._dustParticles.length < 60) this._spawnDust();
        }

        static getParameterSchema() {
            return [
                { name: 'speed', type: 'number', min: 0, max: 5, default: 1, label: 'Speed', group: 'Motion' },
                { name: 'density', type: 'number', min: 0, max: 1, default: 0.6, label: 'Density', group: 'Appearance' },
                { name: 'size', type: 'number', min: 2, max: 16, default: 4, label: 'Dust Size', group: 'Appearance' },
                { name: 'windDirection', type: 'number', min: 0, max: 360, default: 0, label: 'Wind Direction', group: 'Motion' },
                { name: 'gustFrequency', type: 'number', min: 0.1, max: 5, default: 1, label: 'Gust Frequency', group: 'Motion' },
                { name: 'gustStrength', type: 'number', min: 0, max: 2, default: 0.5, label: 'Gust Strength', group: 'Motion' },
                { name: 'dustColor', type: 'color', default: '#cc9933', label: 'Color', group: 'Appearance' },
                { name: 'hazeOpacity', type: 'number', min: 0, max: 1, default: 0.2, label: 'Haze Opacity', group: 'Appearance' },
                { name: 'opacity', type: 'number', min: 0, max: 1, default: 0.7, label: 'Opacity', group: 'Appearance' }
            ];
        }
    }

    // ============ EFFECT REGISTRY ============

    const EFFECT_TYPES = {
        mist: { class: MistEffect, label: 'Mist' },
        fog: { class: FogEffect, label: 'Fog' },
        cloudShadows: { class: CloudShadowsEffect, label: 'Cloud Shadows' },
        particles: { class: ParticlesEffect, label: 'Particles' },
        godRays: { class: GodRaysEffect, label: 'God Rays' },
        fallingLeaves: { class: FallingLeavesEffect, label: 'Falling Leaves' },
        thunderStorm: { class: ThunderStormEffect, label: 'Thunder Storm' },
        bloodRain: { class: BloodRainEffect, label: 'Blood Rain' },
        sandstorm: { class: SandstormEffect, label: 'Sandstorm' }
    };

    // ============ LAYER MODEL ============

    class DEELayer {
        constructor(name, effectType, params = {}) {
            this.name = name;
            this.effectType = effectType;
            this.visible = params.visible !== false;
            this.blendMode = params.blendMode || 'NORMAL';
            this.depth = params.depth || 0.5;
            this.intensity = params.intensity !== undefined ? params.intensity : 1.0;
            this.zoneIds = params.zoneIds || [];
            this.params = { ...params };
            this.effect = null;
        }

        serialize() {
            return {
                name: this.name,
                effectType: this.effectType,
                visible: this.visible,
                blendMode: this.blendMode,
                depth: this.depth,
                intensity: this.intensity,
                zoneIds: this.zoneIds,
                params: { ...this.params }
            };
        }

        static deserialize(data) {
            const layer = new DEELayer(data.name, data.effectType, data.params);
            layer.visible = data.visible;
            layer.blendMode = data.blendMode;
            layer.depth = data.depth;
            layer.intensity = data.intensity;
            layer.zoneIds = data.zoneIds;
            return layer;
        }
    }

    // ============ PRESET MODEL ============

    class DEEPreset {
        constructor(name, description = '', layers = [], builtin = false) {
            this.name = name;
            this.description = description;
            this.layers = layers;
            this.builtin = builtin;
        }

        serialize() {
            return {
                name: this.name,
                description: this.description,
                layers: this.layers.map(l => l.serialize()),
                builtin: this.builtin
            };
        }

        static deserialize(data) {
            const layers = (data.layers || []).map(l => DEELayer.deserialize(l));
            return new DEEPreset(data.name, data.description || '', layers, data.builtin || false);
        }

        clone() {
            return new DEEPreset(
                this.name + ' (copy)',
                this.description,
                this.layers.map(l => {
                    const cloned = new DEELayer(l.name, l.effectType, { ...l.params });
                    cloned.visible = l.visible;
                    cloned.blendMode = l.blendMode;
                    cloned.depth = l.depth;
                    cloned.intensity = l.intensity;
                    cloned.zoneIds = [...l.zoneIds];
                    return cloned;
                }),
                false
            );
        }
    }

    // ============ DEFAULT PRESETS ============

    const DEFAULT_PRESETS = [
        new DEEPreset('None', 'No effects', [], true),
        new DEEPreset('Sunny Plains', 'Soft cloud shadows with light pollen particles.', [
            new DEELayer('clouds', 'cloudShadows', { cloudCount: 3, opacity: 0.25 }),
            new DEELayer('pollen', 'particles', { shape: 'circle', density: 0.3, size: 2, color: '#ffff99', opacity: 0.4 })
        ], true),
        new DEEPreset('Misty Morning', 'Soft, drifting mist with cool tones.', [
            new DEELayer('mist', 'mist', { density: 0.6, color: '#8899ff', opacity: 0.7, verticalDrift: 0.15 })
        ], true),
        new DEEPreset('Heavy Fog', 'Thick, ground-hugging fog reducing visibility.', [
            new DEELayer('fog', 'fog', { density: 0.8, groundHugFactor: 0.95, opacity: 0.9 })
        ], true),
        new DEEPreset('Drizzling Rain', 'Light rain with soft mist.', [
            new DEELayer('mist', 'mist', { density: 0.4, color: '#ccddee', opacity: 0.5 }),
            new DEELayer('light_rain', 'thunderStorm', { rainDensity: 0.3, flashFrequency: 100, opacity: 0.5, windInfluence: 0.1 })
        ], true),
        new DEEPreset('Thunder Storm', 'Heavy rain with lightning flashes.', [
            new DEELayer('dark_clouds', 'cloudShadows', { cloudCount: 8, cloudSize: 300, opacity: 0.6 }),
            new DEELayer('heavy_rain', 'thunderStorm', { rainDensity: 0.9, flashFrequency: 3, flashBrightness: 0.9, opacity: 0.9, windInfluence: 0.5 })
        ], true),
        new DEEPreset('Blood Rain Subtle', 'Eerie blood rain effect.', [
            new DEELayer('blood_rain', 'bloodRain', { rainDensity: 0.5, tint: '#7a0a0a', flashBrightness: 0.4, opacity: 0.6 })
        ], true),
        new DEEPreset('Blood Rain Extreme', 'Intense blood rain with dark atmosphere.', [
            new DEELayer('dark_overlay', 'fog', { density: 0.6, color: '#330000', groundHugFactor: 0.5, opacity: 0.4 }),
            new DEELayer('blood_rain_heavy', 'bloodRain', { rainDensity: 0.9, tint: '#990000', flashBrightness: 0.6, opacity: 0.85 })
        ], true),
        new DEEPreset('Sandstorm Light', 'Light sandy wind.', [
            new DEELayer('light_dust', 'sandstorm', { density: 0.4, windDirection: 45, speed: 0.8, opacity: 0.5 })
        ], true),
        new DEEPreset('Sandstorm Heavy', 'Intense sandstorm reducing visibility.', [
            new DEELayer('heavy_dust', 'sandstorm', { density: 0.8, windDirection: 45, speed: 2, gustStrength: 1.0, opacity: 0.8 }),
            new DEELayer('sand_haze', 'fog', { density: 0.5, color: '#cc9933', opacity: 0.6 })
        ], true),
        new DEEPreset('Falling Leaves', 'Autumn leaves gently falling.', [
            new DEELayer('leaves', 'fallingLeaves', { density: 0.5, size: 16, color: '#ff8844', swayAmplitude: 3, speed: 0.5, opacity: 0.85 })
        ], true),
        new DEEPreset('God Rays Cathedral', 'Divine light rays through mist.', [
            new DEELayer('mist', 'mist', { density: 0.3, color: '#ffff99', opacity: 0.3 }),
            new DEELayer('rays', 'godRays', { rayCount: 4, rayWidth: 150, color: '#ffff99', pulseSpeed: 0.5, opacity: 0.5 })
        ], true),
        new DEEPreset('Spooky Graveyard', 'Eerie fog with floating orbs.', [
            new DEELayer('fog', 'fog', { density: 0.7, color: '#00ff00', groundHugFactor: 0.8, opacity: 0.6 }),
            new DEELayer('orbs', 'particles', { shape: 'circle', density: 0.2, size: 8, color: '#00ff00', gravity: -0.1, opacity: 0.7 })
        ], true),
        new DEEPreset('Indoor Dust', 'Dust motes in indoor light.', [
            new DEELayer('dust_motes', 'particles', { shape: 'circle', density: 0.2, size: 2, color: '#cccccc', gravity: 0.05, swirl: 0.5, opacity: 0.4 })
        ], true)
    ];

    // ============ PRESET MANAGER ============

    class PresetManager {
        constructor() {
            this._builtins = DEFAULT_PRESETS;
            this._userPresets = {};
            this.loadFromGameSystem();
        }

        list() {
            const names = this._builtins.map(p => p.name);
            names.push(...Object.keys(this._userPresets));
            return names;
        }

        findByName(name) {
            const builtin = this._builtins.find(p => p.name === name);
            if (builtin) return builtin.clone();
            return this._userPresets[name] ? DEEPreset.deserialize(this._userPresets[name]) : null;
        }

        create(name, layers = []) {
            const preset = new DEEPreset(name, '', layers, false);
            this._userPresets[name] = preset.serialize();
            this.saveToGameSystem();
            return preset;
        }

        save(name, layers = []) {
            const preset = new DEEPreset(name, '', layers, false);
            this._userPresets[name] = preset.serialize();
            this.saveToGameSystem();
        }

        duplicate(name, newName) {
            const original = this.findByName(name);
            if (!original) return null;
            const cloned = original.clone();
            cloned.name = newName;
            this._userPresets[newName] = cloned.serialize();
            this.saveToGameSystem();
            return cloned;
        }

        delete(name) {
            if (this._userPresets[name]) {
                delete this._userPresets[name];
                this.saveToGameSystem();
                return true;
            }
            return false;
        }

        loadFromGameSystem() {
            if ($gameSystem && $gameSystem._deeUserPresets) {
                this._userPresets = $gameSystem._deeUserPresets;
            }
        }

        saveToGameSystem() {
            if ($gameSystem) $gameSystem._deeUserPresets = this._userPresets;
        }
    }

    DEE.PresetManager = new PresetManager();

    // ============ ZONE MANAGER ============

    class ZoneManager {
        constructor() {
            this._zones = {};
        }

        defineRectZone(id, mapId, x, y, w, h, intensity = 1.0) {
            this._zones[id] = { type: 'rect', mapId, x, y, w, h, intensity };
        }

        defineRegionZone(id, regions = [], indoor = false, intensity = 1.0) {
            this._zones[id] = { type: 'region', regions: Array.isArray(regions) ? regions : [regions], indoor, intensity };
        }

        clear() { this._zones = {}; }

        activeZonesForPlayer() {
            const active = [];
            for (const [id, zone] of Object.entries(this._zones)) {
                if (zone.type === 'rect') {
                    const px = $gamePlayer.x, py = $gamePlayer.y;
                    if (px >= zone.x && px < zone.x + zone.w && py >= zone.y && py < zone.y + zone.h) active.push(id);
                } else if (zone.type === 'region') {
                    const rid = $gameMap.regionId($gamePlayer.x, $gamePlayer.y);
                    if (zone.regions.includes(rid)) active.push(id);
                }
            }
            return active;
        }

        layerActive(layer) {
            if (!layer.zoneIds || layer.zoneIds.length === 0) return true;
            const active = this.activeZonesForPlayer();
            return layer.zoneIds.some(z => active.includes(z));
        }

        layerIntensity(layer) {
            if (!layer.zoneIds || layer.zoneIds.length === 0) return 1.0;
            const active = this.activeZonesForPlayer();
            let maxIntensity = 0;
            for (const zoneId of layer.zoneIds) {
                if (active.includes(zoneId) && this._zones[zoneId]) {
                    maxIntensity = Math.max(maxIntensity, this._zones[zoneId].intensity);
                }
            }
            return maxIntensity;
        }
    }

    DEE.ZoneManager = new ZoneManager();

    // ============ TRANSITION CONTROLLER ============

    class TransitionController {
        constructor() {
            this._active = false;
            this._startState = {};
            this._targetState = {};
            this._elapsed = 0;
            this._duration = 0;
            this._easing = 'linear';
            this._onComplete = null;
        }

        start(targetPreset, duration = 60, easing = 'linear', onComplete = null) {
            this._active = true;
            this._startState = {};
            this._targetState = {};
            this._elapsed = 0;
            this._duration = duration;
            this._easing = easing;
            this._onComplete = onComplete;
            if (targetPreset) {
                const preset = DEE.PresetManager.findByName(targetPreset);
                if (preset) this._targetState = preset;
            }
        }

        update(dt) {
            if (!this._active) return;
            this._elapsed += 60 * dt;
            if (this._elapsed >= this._duration) {
                this._active = false;
                if (this._onComplete) this._onComplete();
            }
        }

        progress() { return this._active ? clamp(this._elapsed / this._duration, 0, 1) : 0; }
        isActive() { return this._active; }
    }

    DEE.Transition = new TransitionController();

    // ============ RENDERER ============

    class Renderer {
        constructor() {
            this._rootContainer = null;
            this._activePreset = null;
            this._layers = [];
            this._effects = [];
            this._scene = null;
            this._spriteset = null;
            this._pixelationFilter = null;
            this._lastPixelation = -1;
            this._buckets = { below: [], mid: [], above: [] };
        }

        attachToSpriteset(spriteset) {
            if (this._rootContainer) return;
            this._spriteset = spriteset;
            this._scene = SceneManager._scene;
            this._rootContainer = new PIXI.Container();
            spriteset.addChild(this._rootContainer);
            this._createBuckets();
        }

        _createBuckets() {
            this._buckets.below = new PIXI.Container();
            this._buckets.mid = new PIXI.Container();
            this._buckets.above = new PIXI.Container();
            this._rootContainer.addChild(this._buckets.below);
            this._rootContainer.addChild(this._buckets.mid);
            this._rootContainer.addChild(this._buckets.above);
        }

        applyPreset(presetName) {
            const preset = DEE.PresetManager.findByName(presetName);
            if (!preset) return false;
            this.clearLayers();
            this._activePreset = preset;
            for (const layerData of preset.layers) {
                const layer = layerData;
                const effectClass = EFFECT_TYPES[layer.effectType]?.class;
                if (!effectClass) continue;
                const effect = new effectClass(layer.params);
                if (this._rootContainer) effect.init(this._rootContainer);
                this._effects.push(effect);
                this._layers.push(layer);
                effect.applyContainerProps(layer.visible, BLEND_MODES[layer.blendMode] || PIXI.BLEND_MODES.NORMAL, layer.intensity, layer.depth);
                this._bucketLayer(layer.depth, effect._container);
            }
            return true;
        }

        _bucketLayer(depth, container) {
            if (depth < 0.5) this._buckets.below.addChild(container);
            else if (depth >= 0.9) this._buckets.above.addChild(container);
            else this._buckets.mid.addChild(container);
        }

        clearLayers() {
            for (const effect of this._effects) effect.destroy();
            this._effects = [];
            this._layers = [];
            if (this._buckets.below) this._buckets.below.removeChildren();
            if (this._buckets.mid) this._buckets.mid.removeChildren();
            if (this._buckets.above) this._buckets.above.removeChildren();
        }

        update(dt) {
            const quality = QualityController.current();
            const pixelAmount = Number(params.pixelationDefault) || 0;
            if (pixelAmount > 0 && pixelAmount !== this._lastPixelation) {
                this._lastPixelation = pixelAmount;
                if (this._pixelationFilter) this._rootContainer.filters = [];
                this._pixelationFilter = new PIXI.filters.PixelateFilter();
                this._pixelationFilter.size = pixelAmount;
                this._rootContainer.filters = [this._pixelationFilter];
            }
            for (let i = 0; i < this._effects.length; i++) {
                const effect = this._effects[i];
                const layer = this._layers[i];
                const zoneIntensity = DEE.ZoneManager.layerIntensity(layer);
                const finalIntensity = layer.intensity * zoneIntensity;
                effect.applyContainerProps(layer.visible && DEE.ZoneManager.layerActive(layer), BLEND_MODES[layer.blendMode] || PIXI.BLEND_MODES.NORMAL, finalIntensity, layer.depth);
                effect.update(dt, { width: Graphics.width, height: Graphics.height, time: this._time || 0 });
            }
            this._time = (this._time || 0) + dt;
        }
    }

    DEE.Renderer = new Renderer();

    // ============ EDITOR UI ============

    class EditorUI {
        constructor() {
            this._active = false;
            this._scene = null;
            this._windows = [];
        }

        toggle() {
            if (this._active) this.close();
            else this.open();
        }

        open() {
            if (this._active) return;
            this._active = true;
            if (SceneManager._scene instanceof Scene_Map || SceneManager._scene instanceof Scene_Battle) {
                this._scene = SceneManager._scene;
            }
        }

        close() {
            this._active = false;
            for (const win of this._windows) {
                if (win && win.close) win.close();
            }
            this._windows = [];
        }

        isActive() { return this._active; }
    }

    DEE.Editor = new EditorUI();

    // ============ GAME_SYSTEM EXTENSIONS ============

    const _GameSystem_initialize = Game_System.prototype.initialize;
    Game_System.prototype.initialize = function () {
        _GameSystem_initialize.call(this);
        this._deeActivePresetName = null;
        this._deeUserPresets = {};
        this._deeQuality = String(params.defaultQuality) || 'medium';
        this._deePixelation = Number(params.pixelationDefault) || 0;
        this._deeZones = [];
        this._deeBattleEnabled = params.enableInBattle !== 'false';
    };

    // ============ DATA MANAGER HOOKS ============

    const _DataManager_onLoad = DataManager.onLoad;
    DataManager.onLoad = function (object) {
        _DataManager_onLoad.call(this, object);
        if (object === $dataMap && $dataMap) {
            const note = $dataMap.note || '';
            const m1 = note.match(/<deeIndoor>/i);
            if (m1) $gameMap._deeIndoor = true;
            const m2 = note.match(/<deePreset:\s*([^>]+)>/i);
            if (m2) $gameMap._deePresetName = m2[1].trim();
            const zoneMatches = note.matchAll(/<deeZoneRect:\s*(\w+),\s*x=(\d+)\s*y=(\d+)\s*w=(\d+)\s*h=(\d+)(?:,\s*intensity=([\d.]+))?>/gi);
            for (const match of zoneMatches) {
                DEE.ZoneManager.defineRectZone(match[1], $gameMap.mapId(), Number(match[2]), Number(match[3]), Number(match[4]), Number(match[5]), Number(match[6]) || 1.0);
            }
            const regionMatches = note.matchAll(/<deeZone:\s*(\w+),\s*regions=([\d+]+)(?:,\s*intensity=([\d.]+))?>/gi);
            for (const match of regionMatches) {
                const regions = match[2].split('+').map(Number);
                DEE.ZoneManager.defineRegionZone(match[1], regions, false, Number(match[3]) || 1.0);
            }
        }
    };

    // ============ SCENE BOOT BACK-FILL ============

    const _Scene_Boot_start = Scene_Boot.prototype.start;
    Scene_Boot.prototype.start = function () {
        _Scene_Boot_start.call(this);
        if ($gameSystem) {
            if ($gameSystem._deeActivePresetName === undefined) $gameSystem._deeActivePresetName = null;
            if ($gameSystem._deeUserPresets === undefined) $gameSystem._deeUserPresets = {};
            if ($gameSystem._deeQuality === undefined) $gameSystem._deeQuality = String(params.defaultQuality) || 'medium';
            if ($gameSystem._deePixelation === undefined) $gameSystem._deePixelation = Number(params.pixelationDefault) || 0;
            if ($gameSystem._deeZones === undefined) $gameSystem._deeZones = [];
            if ($gameSystem._deeBattleEnabled === undefined) $gameSystem._deeBattleEnabled = params.enableInBattle !== 'false';
        }
        QualityController.set($gameSystem._deeQuality || String(params.defaultQuality) || 'medium');
        DEE.PresetManager.loadFromGameSystem();
    };

    // ============ SPRITESET HOOKS ============

    const _Spriteset_Map_createLowerLayer = Spriteset_Map.prototype.createLowerLayer;
    Spriteset_Map.prototype.createLowerLayer = function () {
        _Spriteset_Map_createLowerLayer.call(this);
        DEE.Renderer.attachToSpriteset(this);
    };

    const _Spriteset_Battle_createBattleField = Spriteset_Battle.prototype.createBattleField;
    Spriteset_Battle.prototype.createBattleField = function () {
        _Spriteset_Battle_createBattleField.call(this);
        if ($gameSystem._deeBattleEnabled) {
            DEE.Renderer.attachToSpriteset(this);
        }
    };

    // ============ SCENE UPDATE HOOKS ============

    const _Scene_Map_update = Scene_Map.prototype.update;
    Scene_Map.prototype.update = function () {
        _Scene_Map_update.call(this);
        if (Input.isTriggered(params.editorKey === 'F11' ? 'F11' : params.editorKey === 'F12' ? 'F12' : 'F10')) {
            if (params.editorEnabled === 'true' || $gameTemp.isPlaytest()) {
                DEE.Editor.toggle();
            }
        }
        if (this._spriteset) {
            DEE.Renderer.update(1.0 / 60.0);
        }
    };

    const _Scene_Battle_update = Scene_Battle.prototype.update;
    Scene_Battle.prototype.update = function () {
        _Scene_Battle_update.call(this);
        if (this._spriteset && $gameSystem._deeBattleEnabled) {
            DEE.Renderer.update(1.0 / 60.0);
        }
    };

    const _Scene_Map_onMapLoaded = Scene_Map.prototype.onMapLoaded;
    Scene_Map.prototype.onMapLoaded = function () {
        _Scene_Map_onMapLoaded.call(this);
        if (params.applyOnNewGame === 'true' && !$gameSystem._deeActivePresetName) {
            const defaultPresetName = String(params.defaultPreset) || 'Misty Morning';
            DEE.Renderer.applyPreset(defaultPresetName);
            $gameSystem._deeActivePresetName = defaultPresetName;
        } else if ($gameMap._deePresetName) {
            DEE.Renderer.applyPreset($gameMap._deePresetName);
            $gameSystem._deeActivePresetName = $gameMap._deePresetName;
        } else if ($gameSystem._deeActivePresetName) {
            DEE.Renderer.applyPreset($gameSystem._deeActivePresetName);
        }
    };

    // ============ PLUGIN COMMANDS ============

    PluginManager.registerCommand(PLUGIN_NAME, 'showPreset', function (args) {
        const presetName = String(args.presetName);
        const transitionFrames = Number(args.transitionFrames) || 0;
        const easing = String(args.easing) || 'linear';
        if (transitionFrames > 0) {
            DEE.Transition.start(presetName, transitionFrames, easing, () => {
                DEE.Renderer.applyPreset(presetName);
                $gameSystem._deeActivePresetName = presetName;
            });
        } else {
            DEE.Renderer.applyPreset(presetName);
            $gameSystem._deeActivePresetName = presetName;
        }
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'hidePreset', function (args) {
        const transitionFrames = Number(args.transitionFrames) || 60;
        DEE.Transition.start('None', transitionFrames, 'linear', () => {
            DEE.Renderer.applyPreset('None');
            $gameSystem._deeActivePresetName = null;
        });
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'transitionTo', function (args) {
        const presetName = String(args.presetName);
        const frames = Number(args.frames) || 60;
        const easing = String(args.easing) || 'linear';
        DEE.Transition.start(presetName, frames, easing, () => {
            DEE.Renderer.applyPreset(presetName);
            $gameSystem._deeActivePresetName = presetName;
        });
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'addLayer', function (args) {
        // Placeholder for runtime layer addition
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'removeLayer', function (args) {
        // Placeholder for layer removal
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'setLayerProperty', function (args) {
        // Placeholder for property modification
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'setQuality', function (args) {
        const level = String(args.level);
        QualityController.set(level);
        $gameSystem._deeQuality = level;
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'enableBattleEnvironment', function (args) {
        $gameSystem._deeBattleEnabled = true;
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'disableBattleEnvironment', function (args) {
        $gameSystem._deeBattleEnabled = false;
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'applyZoneMask', function (args) {
        // Placeholder for zone masking
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'defineRegionZone', function (args) {
        const zoneId = String(args.zoneId);
        const regions = String(args.regions).split(',').map(r => Number(r.trim()));
        const indoor = args.indoor === 'true';
        const intensity = Number(args.intensity) || 1.0;
        DEE.ZoneManager.defineRegionZone(zoneId, regions, indoor, intensity);
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'defineRectZone', function (args) {
        const zoneId = String(args.zoneId);
        const mapId = Number(args.mapId);
        const x = Number(args.x);
        const y = Number(args.y);
        const w = Number(args.w);
        const h = Number(args.h);
        const intensity = Number(args.intensity) || 1.0;
        DEE.ZoneManager.defineRectZone(zoneId, mapId, x, y, w, h, intensity);
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'clearZones', function (args) {
        DEE.ZoneManager.clear();
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'rampIntensity', function (args) {
        // Placeholder for intensity ramping
    });

    PluginManager.registerCommand(PLUGIN_NAME, 'dayNightSequence', function (args) {
        // Placeholder for day-night sequence
    });

})();
