import 'package:flutter/material.dart';
import 'features/select_file/screens/select_file_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cut Optimizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1), // Corporate Blue
          primary: const Color(0xFF0D47A1),
          secondary: const Color(0xFF42A5F5),
          background: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Arial', // Or system default
      ),
      home: const SelectFileScreen(),
    );
  }
}
