import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'measurement_record.dart';

/// Web 用浏览器本地存储，避免 sqflite 在 GitHub Pages 上依赖 wasm。
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const _key = 'measurement_records_v1';

  DatabaseHelper._init();

  Future<List<Map<String, dynamic>>> _loadRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null || json.isEmpty) return [];
    final decoded = jsonDecode(json);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> _saveRaw(List<Map<String, dynamic>> rows) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(rows));
  }

  Future<int> insertRecord(MeasurementRecord record) async {
    final rows = await _loadRaw();
    var nextId = 1;
    for (final row in rows) {
      final id = row['id'];
      if (id is num && id.toInt() >= nextId) nextId = id.toInt() + 1;
    }
    final map = record.toMap()..['id'] = nextId;
    rows.add(map);
    await _saveRaw(rows);
    return nextId;
  }

  Future<List<MeasurementRecord>> getRecords({
    int? limit,
    int? offset,
  }) async {
    final rows = await _loadRaw();
    rows.sort((a, b) {
      final ta = (a['timestamp'] as num?)?.toInt() ?? 0;
      final tb = (b['timestamp'] as num?)?.toInt() ?? 0;
      return tb.compareTo(ta);
    });
    var slice = rows;
    if (offset != null) {
      slice = offset >= slice.length ? [] : slice.sublist(offset);
    }
    if (limit != null && slice.length > limit) {
      slice = slice.sublist(0, limit);
    }
    return slice.map(MeasurementRecord.fromMap).toList();
  }

  Future<int> getRecordCount() async {
    final rows = await _loadRaw();
    return rows.length;
  }

  Future<int> deleteRecord(int id) async {
    final rows = await _loadRaw();
    final next = rows.where((row) {
      final value = row['id'];
      final rowId = value is num ? value.toInt() : null;
      return rowId != id;
    }).toList();
    final removed = rows.length - next.length;
    await _saveRaw(next);
    return removed;
  }

  Future<void> deleteAllRecords() async {
    await _saveRaw([]);
  }

  Future<void> close() async {}
}
