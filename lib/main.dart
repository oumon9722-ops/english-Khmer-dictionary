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


  Get.put(MyData());
  // load Data
  DBHelper helper = DBHelper();
  await helper.initDB();

  List result = await helper.db!.rawQuery(
     "SELECT * FROM words where englishword like 'A%' limit 50;",
   
  );

  print(result); // 🔥 DEBUG

  Get.find<MyData>().words.assignAll(result);
  runApp(
    GetMaterialApp(
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
        appBarTheme: Colors.grey[850] != null 
            ? AppBarTheme(backgroundColor: Colors.grey[850],foregroundColor: Colors.white,) 
            : null,
      ),
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/detail': (context) => DetailScreen(),
        '/favorite': (context) => FavoriteScreen(),
        '/history': (context) => HistoryScreen(),
        '/setting': (context) => SettingsScreen(),
        '/aboutapp': (context) => AboutAppScreen(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}


















