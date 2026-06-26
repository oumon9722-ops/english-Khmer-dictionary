import 'package:app/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MyData extends GetxController {
  int index = 0;
  var favoriteWords = <dynamic>[].obs;
  var isDarkMode = false.obs;

  void toggleFavorite(Map<String, dynamic> wordItem) {
    int index = favoriteWords.indexWhere(
      (element) => element['englishword'] == wordItem['englishword'],
    );

    if (index >= 0) {
      favoriteWords.removeAt(index);
    } else {
      favoriteWords.add(wordItem);
    }
  }

  bool isFavorite(Map<String, dynamic> wordItem) {
    return favoriteWords.any(
      (element) => element['englishword'] == wordItem['englishword'],
    );
  }

  var words = <dynamic>[
    {
      "id": "1",
      "englishword": "book",
      "partofspeech": "n",
      "englishphonetic": "bʊk",
      "khmerphonetic": "ប៊ុកខ៍",
    
    },
  ].obs;

  var history = [].obs;
  void deleteHistoryItem(int index) {
    if (index < 0 || index >= history.length) return;
    history.removeAt(index);
  }
  void addToHistory(Map word) {
    history.add(Map<String, dynamic>.from(word));
  }

  final DBHelper _dbHelper = DBHelper();

  Future<void> addNewWord({
    required String english,
    required String pos,
    required String engPhonetic,
    required String khPhonetic,
  }) async {
    await _dbHelper.initDB();

    // Save to the local SQLite database file
    int uniqueId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _dbHelper.db!.insert('words', {
      'id': uniqueId,
      'englishword': english,
      'partofspeech': pos,
      'englishphonetic': engPhonetic,
      'khmerphonetic': khPhonetic,
    });
    Map<String, dynamic> newRow = {
      "id": uniqueId,
      "englishword": english,
      "partofspeech": pos,
      "englishphonetic": engPhonetic,
      "khmerphonetic": khPhonetic,
    };
    words.insert(0, newRow);
  }
  Future<void> filterWords(String query) async {
    if (query.trim().isEmpty) {
      
      await _dbHelper.initDB();
      List defaultList = await _dbHelper.db!.rawQuery(
       "SELECT * FROM words where englishword like 'A%' limit 50;",
      );
      words.assignAll(defaultList);
    } else {
      // Execute the search function already defined in your DBHelper class
      await _dbHelper.initDB();
      List filteredList = await _dbHelper.searchWord(query.trim());
      words.assignAll(filteredList);
    }
  }
  void toggleTheme(bool value) {
  isDarkMode.value = value;
  if (value) {
    Get.changeTheme(ThemeData.dark());
  } else {
    Get.changeTheme(ThemeData.light());
  }
}

  
}
