import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'measurement_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('decibel_meter.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE measurement_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp INTEGER NOT NULL,
        duration INTEGER NOT NULL,
        min_db REAL NOT NULL,
        max_db REAL NOT NULL,
        avg_db REAL NOT NULL,
        p50_db REAL NOT NULL,
        p90_db REAL NOT NULL,
        p95_db REAL NOT NULL
      )
    ''');
  }

  Future<int> insertRecord(MeasurementRecord record) async {
    final db = await database;
    return await db.insert('measurement_records', record.toMap());
  }

  Future<List<MeasurementRecord>> getRecords({
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;

    if (limit != null && offset != null) {
      maps = await db.query(
        'measurement_records',
        orderBy: 'timestamp DESC',
        limit: limit,
        offset: offset,
      );
    } else {
      maps = await db.query(
        'measurement_records',
        orderBy: 'timestamp DESC',
      );
    }

    return List.generate(maps.length, (i) => MeasurementRecord.fromMap(maps[i]));
  }

  Future<int> getRecordCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM measurement_records');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete(
      'measurement_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllRecords() async {
    final db = await database;
    await db.delete('measurement_records');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
