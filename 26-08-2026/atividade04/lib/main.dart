import 'package:flutter/material.dart';

import 'screens/tela_circulo.dart';
import 'screens/tela_losango.dart';
import 'screens/tela_quadrado.dart';
import 'screens/tela_retangulo.dart';
import 'screens/tela_trapezio.dart';
import 'screens/tela_triangulo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: false),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Principal')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Escolha uma opção',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple,
              ),),

              const SizedBox(height: 50),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaCirculoScreen(),
                    ),
                  );
                },
                child: const Text('Calcular Círculo'),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaLosangoScreen(),
                    ),
                  );
                },
                child: const Text('Calcular Losango'),
              ),

              const SizedBox(height: 50),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaQuadradoScreen(),
                    ),
                  );
                },
                child: const Text('Calcular Quadrado'),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaRetanguloScreen(),
                    ),
                  );
                },
                child: const Text('Calcular Retângulo'),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaTrapezioScreen(),
                    ),
                  );
                },
                child: const Text('Calcular Trapézio'),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaTrianguloScreen(),
                    ),
                  );
                },
                child: const Text('Calcular Triângulo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
