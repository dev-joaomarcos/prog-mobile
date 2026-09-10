import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const LanchoneteApp());
}

class LanchoneteApp extends StatelessWidget {
  const LanchoneteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lanchonete Sabor Caseiro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
