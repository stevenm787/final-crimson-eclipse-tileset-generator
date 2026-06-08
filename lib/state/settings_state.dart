import 'package:flutter/foundation.dart';

import '../models/provider_config.dart';
import '../services/settings_service.dart';

/// Reactive wrapper around [SettingsService] that notifies listeners on change.
class SettingsState extends ChangeNotifier {
  final SettingsService _service = SettingsService.instance;

  // ── Initialisation ────────────────────────────────────────────────────

  /// Loads persisted settings from disk. Call once at app startup.
  Future<void> loadSettings() async {
    await _service.load();
    notifyListeners();
  }

  // ── API Keys ──────────────────────────────────────────────────────────

  String get huggingFaceApiToken => _service.huggingFaceApiToken;

  set huggingFaceApiToken(String value) {
    _service.huggingFaceApiToken = value;
    notifyListeners();
  }

  String get googleApiKey => _service.googleApiKey;

  set googleApiKey(String value) {
    _service.googleApiKey = value;
    notifyListeners();
  }

  // ── Model Selection ───────────────────────────────────────────────────

  String get selectedModelId => _service.selectedModelId;

  set selectedModelId(String value) {
    _service.selectedModelId = value;
    notifyListeners();
  }

  String get selectedLoraId => _service.selectedLoraId;

  set selectedLoraId(String value) {
    _service.selectedLoraId = value;
    notifyListeners();
  }

  // ── Local SD ──────────────────────────────────────────────────────────

  String get localSdEndpoint => _service.localSdEndpoint;

  set localSdEndpoint(String value) {
    _service.localSdEndpoint = value;
    notifyListeners();
  }

  // ── Output ────────────────────────────────────────────────────────────

  String get outputDirectory => _service.outputDirectory;

  set outputDirectory(String value) {
    _service.outputDirectory = value;
    notifyListeners();
  }

  int get defaultTileSize => _service.defaultTileSize;

  set defaultTileSize(int value) {
    _service.defaultTileSize = value;
    notifyListeners();
  }

  ProviderId get defaultProvider => _service.defaultProvider;

  set defaultProvider(ProviderId value) {
    _service.defaultProvider = value;
    notifyListeners();
  }

  // ── Display ───────────────────────────────────────────────────────────

  bool get gridOverlay => _service.gridOverlay;

  set gridOverlay(bool value) {
    _service.gridOverlay = value;
    notifyListeners();
  }

  bool get darkMode => _service.darkMode;

  set darkMode(bool value) {
    _service.darkMode = value;
    notifyListeners();
  }

  // ── Persistence ───────────────────────────────────────────────────────

  /// Explicitly flushes settings to disk.
  Future<void> save() async {
    await _service.save();
  }
}
