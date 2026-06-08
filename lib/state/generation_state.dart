import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/generation_result.dart';

/// Tracks the state of an in-progress or completed tileset generation.
class GenerationState extends ChangeNotifier {
  bool _isGenerating = false;
  double _progress = 0.0;
  GenerationResult? _currentResult;
  String? _errorMessage;
  final List<String> _logMessages = [];

  // ── Getters ─────────────────────────────────────────────────────────────

  bool get isGenerating => _isGenerating;
  double get progress => _progress;
  GenerationResult? get currentResult => _currentResult;
  String? get errorMessage => _errorMessage;
  List<String> get logMessages => List.unmodifiable(_logMessages);

  // ── Progress ────────────────────────────────────────────────────────────

  set progress(double value) {
    _progress = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  // ── Logging ─────────────────────────────────────────────────────────────

  /// Appends a timestamped entry to the generation log.
  void addLog(String message) {
    final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
    _logMessages.add('[$timestamp] $message');
    notifyListeners();
  }

  // ── Lifecycle ───────────────────────────────────────────────────────────

  /// Resets transient state and marks generation as in-progress.
  void startGeneration() {
    _isGenerating = true;
    _progress = 0.0;
    _currentResult = null;
    _errorMessage = null;
    addLog('Generation started...');
  }

  /// Records a successful generation result.
  void completeGeneration(GenerationResult result) {
    _isGenerating = false;
    _progress = 1.0;
    _currentResult = result;
    _errorMessage = null;
    addLog(
      'Generation complete - ${result.width}x${result.height} '
      '(${result.generationTime.inMilliseconds}ms)',
    );
    notifyListeners();
  }

  /// Records a generation failure.
  void failGeneration(String error) {
    _isGenerating = false;
    _progress = 0.0;
    _errorMessage = error;
    addLog('Generation failed: $error');
    notifyListeners();
  }

  /// Resets all state to defaults.
  void clear() {
    _isGenerating = false;
    _progress = 0.0;
    _currentResult = null;
    _errorMessage = null;
    _logMessages.clear();
    notifyListeners();
  }
}
