import 'package:app/Controller/mydata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myData = Get.find<MyData>();
    const Color primaryBlue = Color(0xFF1A73E8);
    const Color lightBlueAccent = Color(0xFFE8F0FE);

    return Obx(() {
      final isDark = myData.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'About App',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 46,
                backgroundColor: lightBlueAccent,
                child: const Icon(Icons.menu_book_rounded, size: 54, color: primaryBlue),
              ),
              const SizedBox(height: 16),
              const Text(
                'Smart Dictionary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Smart Dictionary is a fast, offline English-Khmer dictionary featuring 36,000+ words, precise phonetic guides, text-to-speech pronunciation, bookmarks, and search history.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),

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
                      leading: const Icon(Icons.school_outlined, color: primaryBlue),
                      title: const Text('Institution & Course'),
                      subtitle: const Text('National University of Battambang (NUBB)\nYear 4 - Hybrid Mobile App Dev'),
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: isDark ? Colors.grey[700] : Colors.grey[200],
                    ),
                    ListTile(
                      leading: const Icon(Icons.group_outlined, color: primaryBlue),
                      title: const Text('Developers / Authors'),
                      subtitle: const Text(
                        'Hor Tola, Oum On, Ouch Rothphanith, Chetra SreyPhim, Voeurn Sothearoth, Nil Mengieng',
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: isDark ? Colors.grey[700] : Colors.grey[200],
                    ),
                    ListTile(
                      leading: const Icon(Icons.email_outlined, color: primaryBlue),
                      title: const Text('Contact Support'),
                      subtitle: const Text('hortola780@gmail.com / oumon9722@gmail.com'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

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
                      leading: const Icon(Icons.info_outline, color: primaryBlue),
                      title: const Text('Open Source Licenses'),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        showLicensePage(
                          context: context,
                          applicationName: 'Smart Dictionary',
                          applicationVersion: '1.0.0',
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                '© 2026 Smart Dictionary • NUBB. All rights reserved.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    });
  }
}
