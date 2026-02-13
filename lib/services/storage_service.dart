import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _kDiscoveredIds = 'discovered_ids';
  static const _kLastUsedAtMs = 'last_used_at_ms';

  Future<Set<String>> loadDiscoveredIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kDiscoveredIds) ?? <String>[];
    return list.toSet();
  }

  Future<void> saveDiscoveredIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kDiscoveredIds, ids.toList());
  }

  Future<DateTime?> loadLastUsedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_kLastUsedAtMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> saveLastUsedAt(DateTime dt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLastUsedAtMs, dt.millisecondsSinceEpoch);
  }

  bool isOnCooldown({required DateTime? lastUsedAt, Duration cooldown = const Duration(hours: 1)}) {
    if (lastUsedAt == null) return false;
    final now = DateTime.now();
    return now.isBefore(lastUsedAt.add(cooldown));
  }

  Duration remainingCooldown({required DateTime lastUsedAt, Duration cooldown = const Duration(hours: 1)}) {
    final endsAt = lastUsedAt.add(cooldown);
    final now = DateTime.now();
    final diff = endsAt.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }
}
