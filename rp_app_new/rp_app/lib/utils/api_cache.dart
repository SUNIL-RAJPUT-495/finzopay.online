import 'dart:developer';

/// Simple in-memory cache for API responses
class ApiCache {
  static final ApiCache _instance = ApiCache._internal();
  factory ApiCache() => _instance;
  ApiCache._internal();

  // Cache storage: key -> {data, timestamp}
  final Map<String, _CacheEntry> _cache = {};

  // Default cache duration (5 minutes)
  static const Duration defaultCacheDuration = Duration(minutes: 5);

  /// Get cached data if available and not expired
  dynamic get(String key, {Duration? maxAge}) {
    final entry = _cache[key];

    if (entry == null) {
      log("Cache MISS for key: $key");
      return null;
    }

    final age = DateTime.now().difference(entry.timestamp);
    final maxCacheAge = maxAge ?? defaultCacheDuration;

    if (age > maxCacheAge) {
      log("Cache EXPIRED for key: $key (age: ${age.inSeconds}s)");
      _cache.remove(key);
      return null;
    }

    log("Cache HIT for key: $key (age: ${age.inSeconds}s)");
    return entry.data;
  }

  /// Store data in cache
  void set(String key, dynamic data) {
    _cache[key] = _CacheEntry(data: data, timestamp: DateTime.now());
    log("Cache SET for key: $key");
  }

  /// Clear specific cache entry
  void remove(String key) {
    _cache.remove(key);
    log("Cache REMOVE for key: $key");
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
    log("Cache CLEARED");
  }

  /// Clear expired entries
  void clearExpired({Duration? maxAge}) {
    final now = DateTime.now();
    final maxCacheAge = maxAge ?? defaultCacheDuration;

    _cache.removeWhere((key, entry) {
      final age = now.difference(entry.timestamp);
      return age > maxCacheAge;
    });

    log("Cache expired entries cleared");
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime timestamp;

  _CacheEntry({required this.data, required this.timestamp});
}
