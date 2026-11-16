import 'package:app/Controller/mydata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final int currentIndex = 2;

  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color lightBlueAccent = Color(0xFFE8F0FE);

  @override
  Widget build(BuildContext context) {
    final d = Get.find<MyData>();

    return Obx(() {
      final isDark = d.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            "History",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            if (d.history.isNotEmpty)
              IconButton(
                tooltip: "Clear All History",
                icon: const Icon(Icons.delete_forever, color: Colors.white, size: 26),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Clear History?"),
                      content: const Text(
                        "Do you want to delete all search history?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () {
                            d.clearHistory();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Search history cleared"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Text("Clear All", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
        body: d.history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_toggle_off_rounded,
                      size: 80,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "No History Yet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Words you view will appear here.",
                      style: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: d.history.length,
                itemBuilder: (context, index) {
                  final item = Map<String, dynamic>.from(d.history[index]);

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    elevation: 0,
                    color: isDark ? Colors.grey[850] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: isDark ? Colors.grey[750] ?? Colors.grey[700]! : Colors.grey[100]!,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      onTap: () {
                        int wordIdx = d.words.indexWhere(
                          (w) => w['englishword'] == item['englishword'],
                        );
                        if (wordIdx >= 0) {
                          d.index = wordIdx;
                        } else {
                          d.words.insert(0, item);
                          d.index = 0;
                        }
                        Navigator.pushNamed(context, '/detail');
                      },
                      leading: CircleAvatar(
                        backgroundColor: lightBlueAccent,
                        child: const Icon(Icons.history, color: primaryBlue),
                      ),
                      title: Text(
                        item['englishword'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: item['partofspeech'] != null &&
                              item['partofspeech'].toString().isNotEmpty
                          ? Text(
                              "${item['partofspeech']} - ${item['khmerphonetic'] ?? ''}",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            )
                          : (item['khmerphonetic'] != null
                              ? Text(
                                  "${item['khmerphonetic']}",
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                )
                              : null),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                        onPressed: () {
                          d.deleteHistoryItem(index);
                        },
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
                blurRadius: 12,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: isDark ? Colors.grey[850] : Colors.white,
            elevation: 0,
            selectedItemColor: primaryBlue,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
            ),
            onTap: (index) {
              if (index == currentIndex) return;

              if (index == 0) Navigator.pushReplacementNamed(context, '/home');
              if (index == 1) Navigator.pushReplacementNamed(context, '/favorite');
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
        ),
      );
    });
  }
}
