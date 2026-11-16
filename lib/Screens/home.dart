import 'package:app/Controller/mydata.dart';
import 'package:app/Screens/insertword.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;

  // Colors
  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color lightBlueAccent = Color(0xFFE8F0FE);
  static const Color iconGrey = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      try {
        bool available = await _speech.initialize(
          onStatus: (status) {
            if (status == 'done' || status == 'notListening') {
              if (mounted) setState(() => _isListening = false);
            }
          },
          onError: (val) {
            if (mounted) setState(() => _isListening = false);
          },
        );

        if (available) {
          if (mounted) setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) {
              if (mounted) {
                setState(() {
                  _searchController.text = val.recognizedWords;
                });
                Get.find<MyData>().filterWords(val.recognizedWords);
              }
            },
          );
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Voice search is not available on this device"),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) setState(() => _isListening = false);
      }
    } else {
      if (mounted) setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myData = Get.find<MyData>();

    return Obx(() {
      final isDark = myData.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddWordScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryBlue,
          leading: const Icon(
            Icons.menu_book,
            color: Colors.white,
          ),
          title: const Text(
            "Smart Dictionary",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              tooltip: "Refresh words",
              onPressed: () {
                _searchController.clear();
                myData.filterWords('');
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 68),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),
                onChanged: (text) {
                  myData.filterWords(text);
                },
                decoration: InputDecoration(
                  hintText: 'Search for Words...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                    fontSize: 15,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.white,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: primaryBlue,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, color: iconGrey),
                          onPressed: () {
                            _searchController.clear();
                            myData.filterWords('');
                          },
                        ),
                      IconButton(
                        tooltip: _isListening ? "Listening..." : "Voice Search",
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none_rounded,
                          color: _isListening ? Colors.redAccent : iconGrey,
                        ),
                        onPressed: _listen,
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
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
        body: myData.words.isEmpty
            ? const Center(
                child: Text(
                  "No words found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: myData.words.length,
                itemBuilder: (context, index) {
                  final wordItem = myData.words[index];
                  final wordMap = Map<String, dynamic>.from(wordItem);
                  final isFav = myData.isFavorite(wordMap);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    elevation: 0,
                    color: isDark ? Colors.grey[850] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isDark ? Colors.grey[750] ?? Colors.grey[700]! : Colors.grey[200]!,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      onTap: () {
                        myData.index = index;
                        myData.addToHistory(wordMap);
                        Navigator.pushNamed(context, '/detail');
                      },
                      leading: CircleAvatar(
                        backgroundColor: lightBlueAccent,
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: primaryBlue,
                        ),
                      ),
                      title: Text(
                        "${wordItem['englishword'] ?? ''} ${wordItem['partofspeech'] != null && wordItem['partofspeech'].toString().isNotEmpty ? '(${wordItem['partofspeech']})' : ''}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        "${wordItem['englishphonetic'] ?? ''} - ${wordItem['khmerphonetic'] ?? ''}",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: "Edit Word",
                            icon: const Icon(Icons.edit, color: primaryBlue, size: 20),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddWordScreen(wordData: wordMap),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            tooltip: isFav ? "Remove Bookmark" : "Bookmark",
                            icon: Icon(
                              isFav ? Icons.bookmark : Icons.bookmark_border,
                              color: primaryBlue,
                            ),
                            onPressed: () {
                              myData.toggleFavorite(wordMap);
                              bool saved = myData.isFavorite(wordMap);
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
              ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            boxShadow: const [
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
            backgroundColor: isDark ? Colors.grey[850] : Colors.white,
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
              if (index == currentIndex) return;

              if (index == 1) {
                Navigator.pushReplacementNamed(context, '/favorite');
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/history');
              } else if (index == 3) {
                Navigator.pushReplacementNamed(context, '/setting');
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
    });
  }
}
