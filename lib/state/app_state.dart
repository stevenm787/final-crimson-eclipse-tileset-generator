import 'package:flutter/foundation.dart';

import '../data/locations.dart';
import '../data/tileset_specs.dart';
import '../models/location.dart';
import '../models/provider_config.dart';
import '../models/tileset_type.dart';

/// Central application state holding the user's current selections.
class AppState extends ChangeNotifier {
  Location? _selectedLocation;
  late TilesetType _selectedTilesetType;
  int _selectedTileSize;
  ProviderId _selectedProvider;
  String _selectedSheetType;

  AppState()
      : _selectedTilesetType = kTilesetTypes.first,
        _selectedTileSize = 48,
        _selectedProvider = ProviderId.huggingFace,
        _selectedSheetType = 'terrain';

  // ── Location ────────────────────────────────────────────────────────────

  Location? get selectedLocation => _selectedLocation;

  set selectedLocation(Location? value) {
    if (_selectedLocation == value) return;
    _selectedLocation = value;
    notifyListeners();
  }

  // ── Tileset Type ────────────────────────────────────────────────────────

  TilesetType get selectedTilesetType => _selectedTilesetType;

  set selectedTilesetType(TilesetType value) {
    if (_selectedTilesetType == value) return;
    _selectedTilesetType = value;
    notifyListeners();
  }

  // ── Tile Size ───────────────────────────────────────────────────────────

  int get selectedTileSize => _selectedTileSize;

  set selectedTileSize(int value) {
    if (_selectedTileSize == value) return;
    _selectedTileSize = value;
    notifyListeners();
  }

  // ── Provider ────────────────────────────────────────────────────────────

  ProviderId get selectedProvider => _selectedProvider;

  set selectedProvider(ProviderId value) {
    if (_selectedProvider == value) return;
    _selectedProvider = value;
    notifyListeners();
  }

  // ── Sheet Type ──────────────────────────────────────────────────────────

  /// One of: terrain, walls, decor, special.
  String get selectedSheetType => _selectedSheetType;

  set selectedSheetType(String value) {
    if (_selectedSheetType == value) return;
    _selectedSheetType = value;
    notifyListeners();
  }

  /// All available locations.
  List<Location> get locations => kLocations;

  /// All available tileset types.
  List<TilesetType> get tilesetTypes => kTilesetTypes;

  /// All available tile sizes.
  List<int> get tileSizes => kTileSizes;
}
