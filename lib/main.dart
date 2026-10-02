import 'package:flutter/material.dart';

import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color brandColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Katalog Menu Sepatu",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandColor,
          primary: brandColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: brandColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
        ),
      ),
      home: const LoginPage(),
    );
  }
}