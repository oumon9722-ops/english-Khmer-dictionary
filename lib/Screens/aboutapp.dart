import 'package:app/Controller/mydata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myData = Get.find<MyData>();
    // Define matching blue colors from the image theme
    const Color primaryBlue = Color(0xFF1A73E8);
    const Color lightBlueAccent = Color(0xFFE8F0FE);
return Obx(() {
  final isDark = myData.isDarkMode.value;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'About App',
          style: TextStyle(fontWeight: FontWeight.bold),
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
              radius: 50,
              backgroundColor: lightBlueAccent,
              child: const Icon(Icons.book_rounded, size: 60, color: primaryBlue),
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
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Smart Dictionary is a lightweight, offline English-Khmer dictionary built to help students, translators, and language enthusiasts quickly look up words with precise phonetic guides.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.person_outline, color: primaryBlue),
              title: const Text('Developer'),
              subtitle: const Text('Oum On / NUBB'),
              onTap: () {
                // Link to your portfolio/github
              },
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: primaryBlue),
              title: const Text('Contact Support'),
              subtitle: const Text('oumon9722@gmail.com'),
              onTap: () {
                // Trigger email intent
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: primaryBlue),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                // Open privacy policy URL
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: primaryBlue),
              title: const Text('Open Source Licenses'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Smart Dictionary',
                  applicationVersion: '1.0.0',
                );
              },
            ),

            const SizedBox(height: 40),
            const Text(
              '© 2026 Smart Dictionary. All rights reserved.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
    },);
  }
}