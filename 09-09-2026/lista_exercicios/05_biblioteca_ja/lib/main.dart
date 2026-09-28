import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BibliotecaJaApp());
}

class BibliotecaJaApp extends StatelessWidget {
  const BibliotecaJaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca Já',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.brown,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
