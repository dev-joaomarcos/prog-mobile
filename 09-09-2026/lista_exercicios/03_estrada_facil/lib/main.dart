import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EstradaFacilApp());
}

class EstradaFacilApp extends StatelessWidget {
  const EstradaFacilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estrada Fácil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
