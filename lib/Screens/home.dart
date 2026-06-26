import 'package:app/Controller/mydata.dart';
import 'package:app/Screens/insertword.dart';
import 'package:app/dbhelper.dart';
// import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  
  // Define the matching blue colors from the image
  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color lightBlueAccent = Color(0xFFE8F0FE);
  static const Color iconGrey = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWordScreen()),
          );

          DBHelper helper = DBHelper();
          await helper.initDB();

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("Smart Dictionary", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              _searchController.clear();
              Get.find<MyData>().filterWords('');
              FocusScope.of(context).unfocus();
            },
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 64),
          child: Container(
            margin: EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (text) {
                Get.find<MyData>().filterWords(text);
              },
              decoration: InputDecoration(
                hintText: 'Search for Words',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: primaryBlue,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.mic_none_rounded,
                    color: iconGrey,
                  ),
                  onPressed: () {},
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: primaryBlue,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final myData = Get.find<MyData>();

        if (myData.words.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: primaryBlue),
          );
        }

        return ListView.builder(
          itemCount: myData.words.length,
          itemBuilder: (context, index) {
            final wordItem = myData.words[index];

            return GestureDetector(
              onTap: () {
                final myData = Get.find<MyData>();
                if (myData.words.isEmpty) return;
                if (index >= myData.words.length) return;

                myData.index = index;
                myData.addToHistory(
                  Map<String, dynamic>.from(myData.words[index]),
                );

                Navigator.pushNamed(context, '/detail');
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: lightBlueAccent,
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: primaryBlue,
                  ),
                ),
                title: Text(
                  "${wordItem['englishword'] ?? ''} - ${wordItem['partofspeech'] ?? ''}",
                ),
                subtitle: Text(
                  "${wordItem['englishphonetic'] ?? ''} - ${wordItem['khmerphonetic'] ?? ''}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: primaryBlue),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddWordScreen(wordData: wordItem),
                          ),
                        );
                        DBHelper helper = DBHelper();
                        await helper.initDB();
                        List<Map<String, dynamic>> result = await helper.db!
                            .rawQuery("SELECT * FROM words");
                        Get.find<MyData>().words.assignAll(result);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        myData.isFavorite(Map<String, dynamic>.from(wordItem))
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: primaryBlue,
                      ),
                      onPressed: () {
                        myData.toggleFavorite(
                          Map<String, dynamic>.from(wordItem),
                        );
                        bool saved = myData.isFavorite(
                          Map<String, dynamic>.from(wordItem),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              saved
                                  ? "Added to Favorites!"
                                  : "Removed from Favorites!",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryBlue,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
          ),
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });

            if (index == 0) {
              Navigator.pushNamed(context, '/home');
            }
            if (index == 1) {
              Navigator.pushNamed(context, '/favorite');
            }
            if (index == 2) {
              Navigator.pushNamed(context, '/history');
            }
            if (index == 3) {
              Navigator.pushNamed(context, '/setting');
            }
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
      ),
    );
  }
}