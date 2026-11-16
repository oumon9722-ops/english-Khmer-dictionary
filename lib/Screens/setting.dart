import 'package:app/Controller/mydata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final int currentIndex = 3;

  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color lightBlueAccent = Color(0xFFE8F0FE);

  @override
  Widget build(BuildContext context) {
    final myData = Get.find<MyData>();

    return Obx(() {
      final isDark = myData.isDarkMode.value;

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
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // DATA STORAGE SECTION
            Card(
              elevation: 0,
              color: isDark ? Colors.grey[850] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: isDark ? Colors.grey[750] ?? Colors.grey[700]! : Colors.grey[200]!,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.red[50],
                      child: Icon(Icons.delete_forever_outlined, color: Colors.red[400]),
                    ),
                    title: const Text(
                      "Clear History",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      if (myData.history.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Clear History?"),
                            content: const Text("Do you want to delete all search history?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  myData.clearHistory();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("History cleared")),
                                  );
                                },
                                child: const Text("Clear", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("History is already empty")),
                        );
                      }
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: isDark ? Colors.grey[700] : Colors.grey[200],
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink[50],
                      child: Icon(Icons.favorite_border, color: Colors.pink[400]),
                    ),
                    title: const Text(
                      "Clear Favorites",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      if (myData.favoriteWords.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Clear Favorites?"),
                            content: const Text("Do you want to delete all favorite words?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  myData.clearFavorites();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Favorites cleared")),
                                  );
                                },
                                child: const Text("Clear", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No favorite words to clear")),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // PREFERENCES SECTION
            Card(
              elevation: 0,
              color: isDark ? Colors.grey[850] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: isDark ? Colors.grey[750] ?? Colors.grey[700]! : Colors.grey[200]!,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const CircleAvatar(
                      backgroundColor: lightBlueAccent,
                      child: Icon(Icons.volume_up_outlined, color: primaryBlue),
                    ),
                    title: const Text(
                      "Test Voice (TTS)",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () async {
                      FlutterTts tts = FlutterTts();
                      await tts.setLanguage("en-US");
                      await tts.speak("Smart Dictionary pronunciation test");
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: isDark ? Colors.grey[700] : Colors.grey[200],
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple[50],
                      child: Icon(Icons.dark_mode_outlined, color: Colors.purple[400]),
                    ),
                    title: const Text(
                      "Dark Mode",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Switch(
                      value: myData.isDarkMode.value,
                      onChanged: (value) {
                        myData.toggleTheme(value);
                      },
                      activeColor: Colors.purple[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // APPLICATION SECTION
            Card(
              elevation: 0,
              color: isDark ? Colors.grey[850] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: isDark ? Colors.grey[750] ?? Colors.grey[700]! : Colors.grey[200]!,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[50],
                      child: Icon(Icons.info_outlined, color: Colors.orange[400]),
                    ),
                    title: const Text(
                      "About App",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text("Smart Dictionary v1.0"),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      Navigator.pushNamed(context, '/aboutapp');
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: isDark ? Colors.grey[700] : Colors.grey[200],
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: Icon(Icons.exit_to_app_outlined, color: Colors.grey[700]),
                    ),
                    title: const Text(
                      "Exit",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ),
            ),
          ],
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
              if (index == 2) Navigator.pushReplacementNamed(context, '/history');
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
