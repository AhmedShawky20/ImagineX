import 'package:flutter/material.dart';
import 'package:imaginex/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A0070)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1A0070),
      ),
      home: const SplashScreen(),
    );
  }
}
