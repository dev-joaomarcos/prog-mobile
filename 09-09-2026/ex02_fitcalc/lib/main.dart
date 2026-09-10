import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const FitCalcApp());
}

class FitCalcApp extends StatelessWidget {
  const FitCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora fitness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blueAccent, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
