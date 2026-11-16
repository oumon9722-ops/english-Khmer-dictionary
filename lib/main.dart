import 'package:app/Controller/mydata.dart';
import 'package:app/Screens/aboutapp.dart';
import 'package:app/Screens/detail.dart';
import 'package:app/Screens/favorite.dart';
import 'package:app/Screens/history.dart';
import 'package:app/Screens/home.dart';
import 'package:app/Screens/setting.dart';
import 'package:app/Screens/splash.dart';
import 'package:app/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize controller & database
  Get.put(MyData());
  DBHelper helper = DBHelper();
  await helper.initDB();

  // Load initial words
  List result = await helper.db!.rawQuery(
    "SELECT * FROM words WHERE englishword LIKE 'A%' LIMIT 50;",
  );

  Get.find<MyData>().words.assignAll(result);

  runApp(
    GetMaterialApp(
      title: "Smart Dictionary",
      initialRoute: '/splash',
      // DEFINE LIGHT THEME DEFAULTS
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),

      // DEFINE DARK THEME DEFAULTS
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
        ),
      ),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
        '/favorite': (context) => const FavoriteScreen(),
        '/history': (context) => const HistoryScreen(),
        '/setting': (context) => const SettingsScreen(),
        '/aboutapp': (context) => const AboutAppScreen(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
