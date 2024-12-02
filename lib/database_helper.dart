import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LeaderboardDB {
  static final LeaderboardDB _instance = LeaderboardDB._internal();
  static Database? _database;

  factory LeaderboardDB() {
    return _instance;
  }

  LeaderboardDB._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the database
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'leaderboard.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leaderboard(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playerName TEXT,
        score INTEGER,
        categoryId TEXT
      );
    ''');
  }

  Future<void> insertScore(
      String playerName, int score, String categoryId) async {
    final db = await database;
    await db.insert(
      'leaderboard',
      {'playerName': playerName, 'score': score, 'categoryId': categoryId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getLeaderboard(String categoryId) async {
    final db = await database;
    return await db.query(
      'leaderboard',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'score DESC',
      limit: 10,
    );
  }
}