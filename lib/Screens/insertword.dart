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
  TextEditingController englishword = TextEditingController();
  TextEditingController englishphonetic = TextEditingController();
  TextEditingController khmerphonetic = TextEditingController();
  TextEditingController partofspeech = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.wordData != null) {
      englishword.text = widget.wordData!['englishword'] ?? '';
      englishphonetic.text = widget.wordData!['englishphonetic'] ?? '';
      khmerphonetic.text = widget.wordData!['khmerphonetic'] ?? '';
      partofspeech.text = widget.wordData!['partofspeech'] ?? '';
    }
  }

  @override
  void dispose() {
    englishword.dispose();
    partofspeech.dispose();
    khmerphonetic.dispose();
    partofspeech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.wordData != null;
    return Scaffold(
      appBar: AppBar(title: Text("Add Word")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: englishword,
                decoration: InputDecoration(labelText: "English Word"),
              ),

              TextField(
                controller: englishphonetic,
                decoration: InputDecoration(labelText: "English Phonetic"),
              ),

              TextField(
                controller: khmerphonetic,
                decoration: InputDecoration(labelText: "Khmer Phonetic"),
              ),

              TextField(
                controller: partofspeech,
                decoration: InputDecoration(labelText: "Part of Speech"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
  onPressed: () async {
    if (englishword.text.trim().isEmpty || khmerphonetic.text.trim().isEmpty) {
      Get.snackbar("Error", "Please fill in the required fields");
      return;
    }

    DBHelper helper = DBHelper();
    await helper.initDB();

    Map<String, dynamic> row = {
      'englishword': englishword.text.trim(),
      'partofspeech': partofspeech.text.trim(),
      'englishphonetic': englishphonetic.text.trim(),
      'khmerphonetic': khmerphonetic.text.trim(),
     
    };

    if (isEditing) {
      // --- EDIT / UPDATE MODE ---
      row['id'] = widget.wordData!['id']; // Make sure 'id' matches your SQLite primary key name
      await helper.updateWord(row);
      
      Get.snackbar(
        "Success",
        "Word updated successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // --- NEW INSERT MODE ---
      // Option A: Use your helper directly
     final List<Map<String, dynamic>> maxIdResult = await helper.db!.rawQuery('SELECT MAX(id) as max_id FROM words');
    int nextId = 1;
    if (maxIdResult.isNotEmpty && maxIdResult[0]['max_id'] != null) {
      nextId = (maxIdResult[0]['max_id'] as int) + 1;
    }
    
    row['id'] = nextId;
    await helper.db!.insert('words', row);
      // OR Option B: Use your controller method (Uncomment below if you prefer your controller handling inserts)
      /*
      await Get.find<MyData>().addNewWord(
        english: englishword.text.trim(),
        pos: partofspeech.text.trim(),
        engPhonetic: englishphonetic.text.trim(),
        khPhonetic: khmerphonetic.text.trim(),
      );
      */

      Get.snackbar(
        "Success",
        "Word added successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }

    // --- REFRESH STATE FOR BOTH MODES ---
    // This fetches the clean updated data straight from your DB table
    List<Map<String, dynamic>> freshWords = await helper.getAllWords();
    Get.find<MyData>().words.assignAll(freshWords);

    // Close view, return to home safely
    Navigator.pop(context);
  },
  child: Text(isEditing ? "Update Changes" : "Save Word"),
)
            ],
          ),
        ),
      ),
    );
  }
}
