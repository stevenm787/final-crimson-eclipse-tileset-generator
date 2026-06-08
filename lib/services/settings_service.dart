import 'package:shared_preferences/shared_preferences.dart';

import '../models/provider_config.dart';

/// Persists and retrieves user settings via [SharedPreferences].
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  SharedPreferences? _prefs;

  /// Loads all settings from persistent storage.
  ///
  /// Must be called before accessing any property.
  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Persists all pending changes.
  ///
  /// [SharedPreferences] auto-saves on each setter call, but this method
  /// exists for symmetry and potential future backends.
  Future<void> save() async {
    // SharedPreferences persists automatically on each setter call.
  }

  // ── API Keys ──────────────────────────────────────────────────────────

  String get huggingFaceApiToken =>
      _prefs?.getString('huggingFaceApiToken') ?? '';

  set huggingFaceApiToken(String value) =>
      _prefs?.setString('huggingFaceApiToken', value);

  String get googleApiKey => _prefs?.getString('googleApiKey') ?? '';

  set googleApiKey(String value) => _prefs?.setString('googleApiKey', value);

  // ── Model Selection ───────────────────────────────────────────────────

  String get selectedModelId =>
      _prefs?.getString('selectedModelId') ??
      'stabilityai/stable-diffusion-xl-base-1.0';

  set selectedModelId(String value) =>
      _prefs?.setString('selectedModelId', value);

  String get selectedLoraId =>
      _prefs?.getString('selectedLoraId') ?? 'nerijs/pixel-art-xl';

  set selectedLoraId(String value) =>
      _prefs?.setString('selectedLoraId', value);

  // ── Local SD ──────────────────────────────────────────────────────────

  String get localSdEndpoint =>
      _prefs?.getString('localSdEndpoint') ?? 'http://localhost:7860';

  set localSdEndpoint(String value) =>
      _prefs?.setString('localSdEndpoint', value);

  // ── Output ────────────────────────────────────────────────────────────

  String get outputDirectory => _prefs?.getString('outputDirectory') ?? '';

  set outputDirectory(String value) =>
      _prefs?.setString('outputDirectory', value);

  int get defaultTileSize => _prefs?.getInt('defaultTileSize') ?? 48;

  set defaultTileSize(int value) => _prefs?.setInt('defaultTileSize', value);

  ProviderId get defaultProvider {
    final stored = _prefs?.getString('defaultProvider');
    if (stored == null) return ProviderId.huggingFace;
    return ProviderId.values.firstWhere(
      (p) => p.name == stored,
      orElse: () => ProviderId.huggingFace,
    );
  }

  set defaultProvider(ProviderId value) =>
      _prefs?.setString('defaultProvider', value.name);

  // ── Display ───────────────────────────────────────────────────────────

  bool get gridOverlay => _prefs?.getBool('gridOverlay') ?? true;

  set gridOverlay(bool value) => _prefs?.setBool('gridOverlay', value);

  bool get darkMode => _prefs?.getBool('darkMode') ?? true;

  set darkMode(bool value) => _prefs?.setBool('darkMode', value);
}
