import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? db;

  Future<void> initDB() async {
    if (db != null) return;
    db = await loadDB();
  }

  Future<Database> loadDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'englishkhmer.db');

    // copy database from assets first time only
    if (!await File(path).exists()) {
      final data = await rootBundle.load('assets/englishkhmer.db');
      await File(path).writeAsBytes(
        data.buffer.asUint8List(),
        flush: true,
      );
    }

    final database = await openDatabase(path);

    // Create persistent tables for favorites and history if they do not exist
    await database.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        englishword TEXT UNIQUE,
        partofspeech TEXT,
        englishphonetic TEXT,
        khmerphonetic TEXT,
        khmerdef TEXT
      );
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_id INTEGER,
        englishword TEXT,
        partofspeech TEXT,
        englishphonetic TEXT,
        khmerphonetic TEXT,
        khmerdef TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    return database;
  }

  // Get all words (Use with caution due to 36k+ words)
  Future<List<Map<String, dynamic>>> getAllWords() async {
    await initDB();
    return await db!.query('words', limit: 100);
  }

  // Search by English word
  Future<List<Map<String, dynamic>>> searchWord(String text) async {
    await initDB();
    return await db!.rawQuery('''
      SELECT * FROM words 
      WHERE englishword LIKE ? 
      ORDER BY 
        CASE 
          WHEN englishword = ? THEN 1            
          WHEN englishword LIKE ? THEN 2          
          ELSE 3                                  
        END ASC, 
        englishword ASC
      LIMIT 100;                          
    ''', [
      '%$text%', // Matches anything containing the search term
      text,      // Matches exact word
      '$text%',  // Matches words starting with the search term
    ]);
  }

  // Insert new word
  Future<int> insertWord({
    required String englishword,
    required String englishphonetic,
    required String khmerphonetic,
    required String partofspeech,
    String khmerdef = '',
  }) async {
    await initDB();
    final List<Map<String, dynamic>> maxIdResult =
        await db!.rawQuery('SELECT MAX(id) as max_id FROM words');
    int nextId = 1;

    if (maxIdResult.isNotEmpty && maxIdResult[0]['max_id'] != null) {
      nextId = (maxIdResult[0]['max_id'] as int) + 1;
    }
    return await db!.insert(
      'words',
      {
        'id': nextId,
        'englishword': englishword,
        'englishphonetic': englishphonetic,
        'khmerphonetic': khmerphonetic,
        'partofspeech': partofspeech,
        'khmerdef': khmerdef,
      },
    );
  }

  Future<int> updateWord(Map<String, dynamic> word) async {
    await initDB();
    return await db!.update(
      'words',
      word,
      where: 'id = ?',
      whereArgs: [word['id']],
    );
  }

  // Favorites operations
  Future<List<Map<String, dynamic>>> getFavorites() async {
    await initDB();
    return await db!.query('favorites', orderBy: 'id DESC');
  }

  Future<int> addFavorite(Map<String, dynamic> word) async {
    await initDB();
    return await db!.insert(
      'favorites',
      {
        'englishword': word['englishword'] ?? '',
        'partofspeech': word['partofspeech'] ?? '',
        'englishphonetic': word['englishphonetic'] ?? '',
        'khmerphonetic': word['khmerphonetic'] ?? '',
        'khmerdef': word['khmerdef'] ?? '',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeFavorite(String englishword) async {
    await initDB();
    return await db!.delete(
      'favorites',
      where: 'englishword = ?',
      whereArgs: [englishword],
    );
  }

  Future<int> clearFavorites() async {
    await initDB();
    return await db!.delete('favorites');
  }

  // History operations
  Future<List<Map<String, dynamic>>> getHistory() async {
    await initDB();
    return await db!.query('history', orderBy: 'id DESC', limit: 100);
  }

  Future<int> addHistory(Map<String, dynamic> word) async {
    await initDB();
    if (word['englishword'] != null) {
      await db!.delete(
        'history',
        where: 'englishword = ?',
        whereArgs: [word['englishword']],
      );
    }
    return await db!.insert(
      'history',
      {
        'word_id': word['id'] is int ? word['id'] : int.tryParse('${word['id']}') ?? 0,
        'englishword': word['englishword'] ?? '',
        'partofspeech': word['partofspeech'] ?? '',
        'englishphonetic': word['englishphonetic'] ?? '',
        'khmerphonetic': word['khmerphonetic'] ?? '',
        'khmerdef': word['khmerdef'] ?? '',
      },
    );
  }

  Future<int> deleteHistoryByWord(String englishword) async {
    await initDB();
    return await db!.delete(
      'history',
      where: 'englishword = ?',
      whereArgs: [englishword],
    );
  }

  Future<int> clearHistory() async {
    await initDB();
    return await db!.delete('history');
  }
}