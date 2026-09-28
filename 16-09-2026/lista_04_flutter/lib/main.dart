import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const Lista04App());
}

class Lista04App extends StatelessWidget {
  const Lista04App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadoras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}