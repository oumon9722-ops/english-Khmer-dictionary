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

    return await openDatabase(path);
  }

  // Get all words
  Future<List<Map<String, dynamic>>> getAllWords() async {
    return await db!.query('words');
  }

  // Search by English word
  Future<List<Map<String, dynamic>>> searchWord(String text) async {
    return await db!.rawQuery('''
      SELECT * FROM words 
      WHERE englishword LIKE ? 
      ORDER BY 
        CASE 
          WHEN englishword = ? THEN 1            
          WHEN englishword LIKE ? THEN 2          
          ELSE 3                                  
        END ASC, 
        englishword ASC;                          
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
  }) async {
    // the last id ['SELECT MAX(id) as max_id FROM words']
    final List<Map<String, dynamic>> maxIdResult = await db!.rawQuery('SELECT MAX(id) as max_id FROM words'); 
    int nextId = 1; // Default if table is completely empty
    
    if (maxIdResult.isNotEmpty && maxIdResult[0]['max_id'] != null) {
      nextId = (maxIdResult[0]['max_id'] as int) + 1;
    }
    return await db!.insert(
      'words',
      {
        'englishword': englishword,
        'englishphonetic': englishphonetic,
        'khmerphonetic': khmerphonetic,
        'partofspeech': partofspeech,
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
}