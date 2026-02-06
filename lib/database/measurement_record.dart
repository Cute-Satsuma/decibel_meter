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
    return MeasurementRecord(
      id: map['id'] as int?,
      timestamp: map['timestamp'] as int,
      duration: map['duration'] as int,
      minDb: map['min_db'] as double,
      maxDb: map['max_db'] as double,
      avgDb: map['avg_db'] as double,
      p50Db: map['p50_db'] as double,
      p90Db: map['p90_db'] as double,
      p95Db: map['p95_db'] as double,
    );
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
