import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/Controller/mydata.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final int currentIndex = 1;
  List<dynamic> filteredWords = [];
  String currentQuery = "";

  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color lightBlueAccent = Color(0xFFE8F0FE);

  @override
  void initState() {
    super.initState();
    filteredWords = Get.find<MyData>().favoriteWords;
  }

  void _searchWord(String query) {
    currentQuery = query;
    final myData = Get.find<MyData>();
    setState(() {
      filteredWords = myData.favoriteWords
          .where((wordItem) => (wordItem['englishword'] ?? '')
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myData = Get.find<MyData>();

    return Obx(() {
      final isDark = myData.isDarkMode.value;
      final wordsToDisplay =
          currentQuery.isEmpty ? myData.favoriteWords : filteredWords;

      return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            "Favorites",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: _searchWord,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: primaryBlue),
                  hintText: "Search favorite words...",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total ${wordsToDisplay.length} favorite words",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: wordsToDisplay.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 80,
                            color: isDark ? Colors.grey[700] : Colors.grey[400],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "No Favorite Words",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.grey[300] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap 🔖 on words in the Home Screen to save them here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.grey[500] : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: wordsToDisplay.length,
                      itemBuilder: (context, index) {
                        final item = Map<String, dynamic>.from(wordsToDisplay[index]);

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          elevation: 0,
                          color: isDark ? Colors.grey[850] : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: isDark ? Colors.grey[750] ?? Colors.grey[700]! : Colors.grey[200]!,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            onTap: () {
                              int wordIdx = myData.words.indexWhere(
                                (w) => w['englishword'] == item['englishword'],
                              );
                              if (wordIdx >= 0) {
                                myData.index = wordIdx;
                              } else {
                                myData.words.insert(0, item);
                                myData.index = 0;
                              }
                              myData.addToHistory(item);
                              Navigator.pushNamed(context, '/detail');
                            },
                            leading: CircleAvatar(
                              backgroundColor: lightBlueAccent,
                              child: const Icon(
                                Icons.lightbulb_outline,
                                color: primaryBlue,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  item['englishword'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if ((item['partofspeech'] ?? '').toString().isNotEmpty)
                                  Text(
                                    "- ${item['partofspeech']}",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "${item['englishphonetic'] ?? ''} ${item['khmerphonetic'] ?? ''}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.grey[300] : Colors.black87,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.bookmark, color: primaryBlue),
                              onPressed: () {
                                myData.toggleFavorite(item);

                                if (currentQuery.isNotEmpty) {
                                  _searchWord(currentQuery);
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Removed '${item['englishword']}' from Favorites",
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? Colors.grey[850] : Colors.white,
          selectedItemColor: primaryBlue,
          unselectedItemColor: const Color(0xFF94A3B8),
          onTap: (index) {
            if (index == currentIndex) return;

            if (index == 0) Navigator.pushReplacementNamed(context, '/home');
            if (index == 2) Navigator.pushReplacementNamed(context, '/history');
            if (index == 3) Navigator.pushReplacementNamed(context, '/setting');
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      );
    });
  }
}
