import 'package:app/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyData extends GetxController {
  int index = 0;
  var favoriteWords = <dynamic>[].obs;
  var history = <dynamic>[].obs;
  var isDarkMode = false.obs;

  final DBHelper _dbHelper = DBHelper();

  var words = <dynamic>[
    {
      "id": "1",
      "englishword": "book",
      "partofspeech": "n",
      "englishphonetic": "bʊk",
      "khmerphonetic": "ប៊ុកខ៍",
      "khmerdef": "សៀវភៅ",
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadPersistedData();
  }

  // Load persistent favorites and search history from SQLite
  Future<void> loadPersistedData() async {
    await _dbHelper.initDB();
    final favs = await _dbHelper.getFavorites();
    favoriteWords.assignAll(favs);

    final hist = await _dbHelper.getHistory();
    history.assignAll(hist);
  }

  // Toggle favorite with SQLite persistence
  Future<void> toggleFavorite(Map<String, dynamic> wordItem) async {
    await _dbHelper.initDB();
    int existingIndex = favoriteWords.indexWhere(
      (element) => element['englishword'] == wordItem['englishword'],
    );

    if (existingIndex >= 0) {
      favoriteWords.removeAt(existingIndex);
      await _dbHelper.removeFavorite(wordItem['englishword'] ?? '');
    } else {
      favoriteWords.insert(0, wordItem);
      await _dbHelper.addFavorite(wordItem);
    }
  }

  bool isFavorite(Map<String, dynamic> wordItem) {
    return favoriteWords.any(
      (element) => element['englishword'] == wordItem['englishword'],
    );
  }

  Future<void> clearFavorites() async {
    favoriteWords.clear();
    await _dbHelper.clearFavorites();
  }

  // History with SQLite persistence
  Future<void> addToHistory(Map word) async {
    final wordMap = Map<String, dynamic>.from(word);
    history.removeWhere(
      (element) => element['englishword'] == wordMap['englishword'],
    );
    history.insert(0, wordMap);
    await _dbHelper.addHistory(wordMap);
  }

  Future<void> deleteHistoryItem(int index) async {
    if (index < 0 || index >= history.length) return;
    final item = history[index];
    history.removeAt(index);
    if (item['englishword'] != null) {
      await _dbHelper.deleteHistoryByWord(item['englishword']);
    }
  }

  Future<void> clearHistory() async {
    history.clear();
    await _dbHelper.clearHistory();
  }

  Future<void> addNewWord({
    required String english,
    required String pos,
    required String engPhonetic,
    required String khPhonetic,
    String khmerDef = '',
  }) async {
    await _dbHelper.initDB();

    int insertedId = await _dbHelper.insertWord(
      englishword: english,
      englishphonetic: engPhonetic,
      khmerphonetic: khPhonetic,
      partofspeech: pos,
      khmerdef: khmerDef,
    );

    Map<String, dynamic> newRow = {
      "id": insertedId,
      "englishword": english,
      "partofspeech": pos,
      "englishphonetic": engPhonetic,
      "khmerphonetic": khPhonetic,
      "khmerdef": khmerDef,
    };
    words.insert(0, newRow);
  }

  Future<void> filterWords(String query) async {
    await _dbHelper.initDB();
    if (query.trim().isEmpty) {
      List defaultList = await _dbHelper.db!.rawQuery(
        "SELECT * FROM words WHERE englishword LIKE 'A%' LIMIT 50;",
      );
      words.assignAll(defaultList);
    } else {
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
