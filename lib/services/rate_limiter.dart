/// A simple sliding-window rate limiter.
///
/// Tracks request timestamps and enforces a maximum number of requests
/// within a rolling time window. Used to stay within HuggingFace and
/// other provider rate limits.
class RateLimiter {
  /// Creates a rate limiter that allows [maxRequests] within [window].
  RateLimiter({
    required this.maxRequests,
    required this.window,
  });

  /// Maximum number of requests allowed in the time [window].
  final int maxRequests;

  /// The sliding time window over which requests are counted.
  final Duration window;

  /// Timestamps of requests that fall within the current window.
  final List<DateTime> _timestamps = [];

  /// Removes timestamps that have fallen outside the current window.
  void _removeExpired() {
    final cutoff = DateTime.now().subtract(window);
    _timestamps.removeWhere((t) => t.isBefore(cutoff));
  }

  /// Returns `true` if a request can proceed without exceeding the limit.
  bool canProceed() {
    _removeExpired();
    return _timestamps.length < maxRequests;
  }

  /// Waits until a request can proceed, then records the request.
  ///
  /// If the rate limit is already reached, this method will delay
  /// until the oldest request expires from the window.
  Future<void> acquire() async {
    _removeExpired();

    while (_timestamps.length >= maxRequests) {
      // Calculate how long to wait for the oldest request to expire.
      final oldest = _timestamps.first;
      final expiresAt = oldest.add(window);
      final waitDuration = expiresAt.difference(DateTime.now());

      if (waitDuration.isNegative) {
        // Already expired; remove and recheck.
        _removeExpired();
        continue;
      }

      // Add a small buffer to avoid tight timing races.
      await Future<void>.delayed(waitDuration + const Duration(milliseconds: 50));
      _removeExpired();
    }

    _timestamps.add(DateTime.now());
  }
}
