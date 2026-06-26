import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/Controller/mydata.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int currentIndex = 1;
  List<dynamic> filteredWords = [];
  String currentQuery = "";

  // Define matching blue colors from the image
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
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myData = Get.find<MyData>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Favorite",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Correctly fallback to the raw list when there is no search query
        final wordsToDisplay = currentQuery.isEmpty ? myData.favoriteWords : filteredWords;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: _searchWord,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: primaryBlue),
                  hintText: "Search favorite words...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total ${wordsToDisplay.length} favorite words",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: wordsToDisplay.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 15),
                          Text(
                            "No Favorite Words",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Add words by tapping 🔖\nin the Home Screen",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: wordsToDisplay.length,
                      itemBuilder: (context, index) {
                        final item = wordsToDisplay[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey[200]!),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: lightBlueAccent,
                              child: Icon(Icons.lightbulb_outline, color: primaryBlue),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  item['englishword'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "- ${item['partofspeech'] ?? ''}",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "${item['englishphonetic'] ?? ''} ${item['khmerphonetic'] ?? ''}",
                                style: TextStyle(fontSize: 15, color: Colors.black87),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.bookmark, color: primaryBlue),
                              onPressed: () {
                                myData.toggleFavorite(Map<String, dynamic>.from(item));

                                if (currentQuery.isNotEmpty) {
                                  _searchWord(currentQuery);
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Removed '${item['englishword']}' from Favorites"),
                                    duration: Duration(seconds: 1),
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
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: const Color(0xFF94A3B8),
        onTap: (index) {
          if (index == currentIndex) return;

          setState(() {
            currentIndex = index;
          });

          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) Navigator.pushReplacementNamed(context, '/favorite');
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
  }
}