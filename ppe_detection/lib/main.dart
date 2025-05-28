import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detection_screen.dart';

void main() {
  runApp(const PPEDetectionApp());
}

class PPEDetectionApp extends StatelessWidget {
  const PPEDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPE Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1e40af), // blue-800
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1e40af),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/detection': (context) => const DetectionScreen(),
      },
    );
  }
}