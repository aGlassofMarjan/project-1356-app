import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/daily_entry.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'project_1356.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE daily_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day_number INTEGER UNIQUE NOT NULL,
        image_path TEXT NOT NULL,
        note TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  // Insert a new daily entry
  Future<int> insertEntry(DailyEntry entry) async {
    final db = await database;
    return await db.insert(
      'daily_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get entry by day number
  Future<DailyEntry?> getEntryByDayNumber(int dayNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_entries',
      where: 'day_number = ?',
      whereArgs: [dayNumber],
    );

    if (maps.isEmpty) return null;
    return DailyEntry.fromMap(maps.first);
  }

  // Get all entries
  Future<List<DailyEntry>> getAllEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('daily_entries');
    return List.generate(maps.length, (i) => DailyEntry.fromMap(maps[i]));
  }

  // Get entries for a range of day numbers
  Future<List<DailyEntry>> getEntriesInRange(int startDay, int endDay) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_entries',
      where: 'day_number >= ? AND day_number <= ?',
      whereArgs: [startDay, endDay],
      orderBy: 'day_number ASC',
    );
    return List.generate(maps.length, (i) => DailyEntry.fromMap(maps[i]));
  }

  // Get count of completed days
  Future<int> getCompletedDaysCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM daily_entries');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Update an entry
  Future<int> updateEntry(DailyEntry entry) async {
    final db = await database;
    return await db.update(
      'daily_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // Delete an entry
  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete(
      'daily_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Check if entry exists for a day
  Future<bool> hasEntryForDay(int dayNumber) async {
    final entry = await getEntryByDayNumber(dayNumber);
    return entry != null;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
