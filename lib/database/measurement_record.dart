class MeasurementRecord {
  final int? id;
  final int timestamp;
  final int duration; // 测量时长（秒）
  final double minDb;
  final double maxDb;
  final double avgDb;
  final double p50Db;
  final double p90Db;
  final double p95Db;

  MeasurementRecord({
    this.id,
    required this.timestamp,
    required this.duration,
    required this.minDb,
    required this.maxDb,
    required this.avgDb,
    required this.p50Db,
    required this.p90Db,
    required this.p95Db,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'duration': duration,
      'min_db': minDb,
      'max_db': maxDb,
      'avg_db': avgDb,
      'p50_db': p50Db,
      'p90_db': p90Db,
      'p95_db': p95Db,
    };
  }

  factory MeasurementRecord.fromMap(Map<String, dynamic> map) {
    int? asInt(Object? value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return null;
    }

    double asDouble(Object? value) {
      if (value is double) return value;
      if (value is num) return value.toDouble();
      return 0;
    }

    return MeasurementRecord(
      id: asInt(map['id']),
      timestamp: asInt(map['timestamp']) ?? 0,
      duration: asInt(map['duration']) ?? 0,
      minDb: asDouble(map['min_db']),
      maxDb: asDouble(map['max_db']),
      avgDb: asDouble(map['avg_db']),
      p50Db: asDouble(map['p50_db']),
      p90Db: asDouble(map['p90_db']),
      p95Db: asDouble(map['p95_db']),
    );
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
