import 'package:app/Controller/mydata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:html/parser.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentIndex = 0;
  final FlutterTts flutterTts = FlutterTts();

  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color lightBlueAccent = Color(0xFFE8F0FE);

  @override
  Widget build(BuildContext context) {
    final MyData d = Get.find<MyData>();

    // SAFE CHECK
    if (d.words.isEmpty || d.index >= d.words.length) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          title: const Text("Detail"),
        ),
        body: const Center(
          child: Text("No word data found"),
        ),
      );
    }

    return Obx(() {
      final isDark = d.isDarkMode.value;
      final currentWord = Map<String, dynamic>.from(d.words[d.index]);
      final isFav = d.isFavorite(currentWord);

      return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text("Detail", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 120),
            child: Column(
              children: [
                Text(
                  "${currentWord['englishword'] ?? ''}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if ((currentWord['partofspeech'] ?? '').toString().isNotEmpty)
                  Text(
                    "${currentWord['partofspeech']}",
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: "Copy Phonetics",
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text:
                                "${currentWord['englishphonetic'] ?? ''} - ${currentWord['khmerphonetic'] ?? ''}",
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Phonetics copied to clipboard"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, color: Colors.white),
                    ),
                    IconButton(
                      tooltip: isFav ? "Remove Favorite" : "Add Favorite",
                      onPressed: () {
                        d.toggleFavorite(currentWord);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFav
                                  ? "Removed from Favorites!"
                                  : "Added to Favorites!",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.redAccent : Colors.white,
                      ),
                    ),
                    IconButton(
                      tooltip: "Share Word",
                      onPressed: () {
                        Share.share(
                          "Word: ${currentWord['englishword'] ?? ''}\n"
                          "Phonetic: ${currentWord['englishphonetic'] ?? ''} (${currentWord['khmerphonetic'] ?? ''})\n"
                          "Definition: ${currentWord['khmerdef'] ?? ''}",
                        );
                      },
                      icon: const Icon(Icons.share, color: Colors.white),
                    ),
                    IconButton(
                      tooltip: "Pronounce",
                      onPressed: () async {
                        await flutterTts.setLanguage("en-US");
                        await flutterTts.setPitch(1.0);
                        await flutterTts.setSpeechRate(0.5);
                        await flutterTts.speak(currentWord['englishword'] ?? '');
                      },
                      icon: const Icon(Icons.volume_up, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Phonetics",
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(
                                text:
                                    "${currentWord['englishphonetic'] ?? ''} - ${currentWord['khmerphonetic'] ?? ''}",
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Phonetics copied"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 4),
                    Text(
                      "English: [${currentWord['englishphonetic'] ?? 'N/A'}]",
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Khmer: {${currentWord['khmerphonetic'] ?? 'N/A'}}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Definition",
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
                          onPressed: () async {
                            String htmlContent = currentWord['khmerdef'] ?? "";
                            String plain = parse(htmlContent).body?.text ?? "";
                            await Clipboard.setData(ClipboardData(text: plain));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Definition copied"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Html(
                      data: (currentWord['khmerdef'] ?? '').toString().isEmpty
                          ? "<p>No definition available.</p>"
                          : currentWord['khmerdef'],
                      style: {
                        "body": Style(
                          fontSize: FontSize(16),
                          color: isDark ? Colors.white70 : Colors.black87,
                          lineHeight: LineHeight(1.5),
                        ),
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: primaryBlue,
          unselectedItemColor: Colors.grey,
          backgroundColor: isDark ? Colors.grey[850] : Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            } else if (index == 1) {
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
      );
    });
  }
}
