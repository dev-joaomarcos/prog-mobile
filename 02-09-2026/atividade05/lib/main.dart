import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
 
void main() {
  runApp(const CalculadoraTrabalhistaApp());
}
 
class CalculadoraTrabalhistaApp extends StatelessWidget {
  const CalculadoraTrabalhistaApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Trabalhista',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
