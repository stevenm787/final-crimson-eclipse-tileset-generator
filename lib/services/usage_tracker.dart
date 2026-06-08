import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks per-provider API usage with daily and monthly counters
/// persisted via [SharedPreferences].
///
/// Storage keys follow the pattern:
///   - Daily:   `usage_<providerId>_<yyyy-MM-dd>`
///   - Monthly: `usage_monthly_<providerId>_<yyyy-MM>`
class UsageTracker {
  /// Creates a new [UsageTracker]. Call [init] before recording or
  /// querying usage.
  UsageTracker();

  SharedPreferences? _prefs;

  static final _dayFormat = DateFormat('yyyy-MM-dd');
  static final _monthFormat = DateFormat('yyyy-MM');

  /// Initialises the tracker by loading [SharedPreferences].
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _safePrefs {
    final p = _prefs;
    if (p == null) {
      throw StateError(
        'UsageTracker has not been initialised. Call init() first.',
      );
    }
    return p;
  }

  // ── Key helpers ──────────────────────────────────────────────────────

  String _dailyKey(String providerId, DateTime date) =>
      'usage_${providerId}_${_dayFormat.format(date)}';

  String _monthlyKey(String providerId, DateTime date) =>
      'usage_monthly_${providerId}_${_monthFormat.format(date)}';

  // ── Public API ───────────────────────────────────────────────────────

  /// Records one usage event for [providerId] at the current time.
  Future<void> recordUsage(String providerId) async {
    final now = DateTime.now();
    final prefs = _safePrefs;

    // Increment daily counter.
    final dKey = _dailyKey(providerId, now);
    final currentDaily = prefs.getInt(dKey) ?? 0;
    await prefs.setInt(dKey, currentDaily + 1);

    // Increment monthly counter.
    final mKey = _monthlyKey(providerId, now);
    final currentMonthly = prefs.getInt(mKey) ?? 0;
    await prefs.setInt(mKey, currentMonthly + 1);
  }

  /// Returns the number of requests made today for [providerId].
  Future<int> getUsageToday(String providerId) async {
    final prefs = _safePrefs;
    final key = _dailyKey(providerId, DateTime.now());
    return prefs.getInt(key) ?? 0;
  }

  /// Returns the number of requests made this calendar month for [providerId].
  Future<int> getUsageThisMonth(String providerId) async {
    final prefs = _safePrefs;
    final key = _monthlyKey(providerId, DateTime.now());
    return prefs.getInt(key) ?? 0;
  }

  /// Resets the daily counter for all providers if the stored "last day"
  /// marker differs from today.
  ///
  /// Call this at app startup or before recording usage to keep counters
  /// accurate across day boundaries.
  Future<void> resetIfNewDay() async {
    final prefs = _safePrefs;
    final today = _dayFormat.format(DateTime.now());
    final lastDay = prefs.getString('usage_last_day');

    if (lastDay != null && lastDay != today) {
      // Remove all daily keys from the previous day.
      final keys = prefs.getKeys();
      final oldPrefix = 'usage_';
      for (final key in keys) {
        if (key.startsWith(oldPrefix) &&
            !key.startsWith('usage_monthly_') &&
            key != 'usage_last_day' &&
            !key.endsWith(today)) {
          await prefs.remove(key);
        }
      }
    }

    await prefs.setString('usage_last_day', today);
  }

  /// Resets the monthly counter for all providers if the stored "last month"
  /// marker differs from this month.
  Future<void> resetIfNewMonth() async {
    final prefs = _safePrefs;
    final thisMonth = _monthFormat.format(DateTime.now());
    final lastMonth = prefs.getString('usage_last_month');

    if (lastMonth != null && lastMonth != thisMonth) {
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith('usage_monthly_') &&
            key != 'usage_last_month' &&
            !key.endsWith(thisMonth)) {
          await prefs.remove(key);
        }
      }
    }

    await prefs.setString('usage_last_month', thisMonth);
  }
}
