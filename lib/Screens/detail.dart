import 'package:app/Controller/mydata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:html/parser.dart';

class DetailScreen extends StatefulWidget {
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentIndex = 0;

  FlutterTts flutterTts = FlutterTts();

  // Color Constants
  static const Color primaryBlue = Color(0xFF1A73E8);

  @override
  Widget build(BuildContext context) {
    MyData d = Get.find<MyData>();
    // SAFE CHECK (IMPORTANT)
    if (d.words.isEmpty || d.index >= d.words.length) {
      return Scaffold(
        body: Center(
          child: Text("No data found"),
        ),
      );
    }
return Obx(() {
  final isDark = d.isDarkMode.value;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryBlue, // Changed from green.shade600
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("Detail", style: TextStyle(color: Colors.white)),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.apps, color: Colors.white))],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 120),
          child: Column(
            children: [
              Text(
                "${d.words[d.index]['englishword']}",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "${d.words[d.index]['partofspeech']}",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text:
                              "${d.words[d.index]['englishphonetic']} - ${d.words[d.index]['khmerphonetic']}",
                        ),
                      );

                      Get.snackbar("Copied", "Phonetic copied");
                    },
                    icon: Icon(Icons.copy, color: Colors.white),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.favorite, color: Colors.white)),
                  IconButton(
                    onPressed: () {
                      Share.share(
                        "${d.words[d.index]['englishword']}\n"
                        "${d.words[d.index]['englishphonetic']}\n"
                        "${d.words[d.index]['khmerdef']}",
                      );
                    },
                    icon: Icon(Icons.share, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () async {
                      await flutterTts.setLanguage("en-US");
                      await flutterTts.setPitch(1.0);
                      await flutterTts.setSpeechRate(0.5);

                      await flutterTts.speak(d.words[d.index]['englishword']);
                    },
                    icon: Icon(Icons.volume_up, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phonetic",
                        style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold), // Accented label
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: Colors.grey),
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(
                              text:
                                  "${d.words[d.index]['englishphonetic']} - ${d.words[d.index]['khmerphonetic']}",
                            ),
                          );

                          Get.snackbar("Copied", "Phonetic copied");
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                    "${d.words[d.index]['englishphonetic']} - {${d.words[d.index]['khmerphonetic']}}",
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Definition",
                        style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold), // Accented label
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: Colors.grey),
                        onPressed: () async {
                          String html = d.words[d.index]['khmerdef'] ?? "";
                          String text = parse(html).body?.text ?? "";

                          await Clipboard.setData(ClipboardData(text: text));

                          Get.snackbar("Copied", "Definition copied");
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  Html(data: d.words[d.index]['khmerdef'] ?? ""),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryBlue, // Changed from orange
        unselectedItemColor: Colors.grey, // Cleaned up random green colors
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
    },);
  }
}