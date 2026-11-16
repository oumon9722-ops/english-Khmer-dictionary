import 'package:app/Controller/mydata.dart';
import 'package:app/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWordScreen extends StatefulWidget {
  final Map<String, dynamic>? wordData;

  const AddWordScreen({Key? key, this.wordData}) : super(key: key);

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final TextEditingController englishword = TextEditingController();
  final TextEditingController englishphonetic = TextEditingController();
  final TextEditingController khmerphonetic = TextEditingController();
  final TextEditingController partofspeech = TextEditingController();
  final TextEditingController khmerdef = TextEditingController();

  static const Color primaryBlue = Color(0xFF1A73E8);

  @override
  void initState() {
    super.initState();
    if (widget.wordData != null) {
      englishword.text = widget.wordData!['englishword'] ?? '';
      englishphonetic.text = widget.wordData!['englishphonetic'] ?? '';
      khmerphonetic.text = widget.wordData!['khmerphonetic'] ?? '';
      partofspeech.text = widget.wordData!['partofspeech'] ?? '';
      khmerdef.text = widget.wordData!['khmerdef'] ?? '';
    }
  }

  @override
  void dispose() {
    englishword.dispose();
    englishphonetic.dispose();
    khmerphonetic.dispose();
    partofspeech.dispose();
    khmerdef.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.wordData != null;
    final myData = Get.find<MyData>();

    return Obx(() {
      final isDark = myData.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          title: Text(
            isEditing ? "Edit Word" : "Add New Word",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: isDark ? Colors.grey[850] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: englishword,
                        decoration: InputDecoration(
                          labelText: "English Word *",
                          prefixIcon: const Icon(Icons.language, color: primaryBlue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: partofspeech,
                        decoration: InputDecoration(
                          labelText: "Part of Speech (e.g. n, v, adj)",
                          prefixIcon: const Icon(Icons.category, color: primaryBlue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: englishphonetic,
                        decoration: InputDecoration(
                          labelText: "English Phonetic (IPA, e.g. bʊk)",
                          prefixIcon: const Icon(Icons.record_voice_over, color: primaryBlue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: khmerphonetic,
                        decoration: InputDecoration(
                          labelText: "Khmer Phonetic * (e.g. ប៊ុកខ៍)",
                          prefixIcon: const Icon(Icons.translate, color: primaryBlue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: khmerdef,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Khmer Definition (Meaning)",
                          hintText: "Enter Khmer definition or explanation",
                          alignLabelWithHint: true,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 60),
                            child: Icon(Icons.menu_book, color: primaryBlue),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (englishword.text.trim().isEmpty || khmerphonetic.text.trim().isEmpty) {
                    Get.snackbar(
                      "Required Fields",
                      "Please fill in at least the English Word and Khmer Phonetic",
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  DBHelper helper = DBHelper();
                  await helper.initDB();

                  Map<String, dynamic> row = {
                    'englishword': englishword.text.trim(),
                    'partofspeech': partofspeech.text.trim(),
                    'englishphonetic': englishphonetic.text.trim(),
                    'khmerphonetic': khmerphonetic.text.trim(),
                    'khmerdef': khmerdef.text.trim(),
                  };

                  if (isEditing) {
                    row['id'] = widget.wordData!['id'];
                    await helper.updateWord(row);

                    // Update locally in controller list
                    int idx = myData.words.indexWhere((w) => w['id'] == row['id']);
                    if (idx >= 0) {
                      myData.words[idx] = row;
                    }

                    Get.snackbar(
                      "Success",
                      "Word updated successfully!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    int nextId = await helper.insertWord(
                      englishword: row['englishword'],
                      englishphonetic: row['englishphonetic'],
                      khmerphonetic: row['khmerphonetic'],
                      partofspeech: row['partofspeech'],
                      khmerdef: row['khmerdef'],
                    );
                    row['id'] = nextId;

                    // Add to top of visible words
                    myData.words.insert(0, row);

                    Get.snackbar(
                      "Success",
                      "Word added successfully!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(
                  isEditing ? "Update Changes" : "Save Word",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
