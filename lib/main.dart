import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/main_screen.dart';

void main() {
  runApp(const MagicBookApp());
}

class MagicBookApp extends StatelessWidget {
  const MagicBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6A5ACD),
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '마법의 고민해결 책',
      theme: base.copyWith(
        textTheme: GoogleFonts.cinzelTextTheme(base.textTheme).apply(
          bodyColor: const Color(0xFFE6E6FA),
          displayColor: const Color(0xFFE6E6FA),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0C29),
      ),
      home: const MainScreen(),
    );
  }
}
