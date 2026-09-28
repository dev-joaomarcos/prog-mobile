import 'package:flutter/material.dart';

import 'custo_por_uso_screen.dart';
import 'juros_compostos_screen.dart';
import 'imposto_sobre_compra_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _abrirTela(BuildContext context, Widget tela) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadoras financeiras'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                color: Colors.white,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calculate_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Escolha uma calculadora',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _BotaoCalculadora(
                        texto: 'Custo por uso de um produto',
                        icone: Icons.shopping_bag_outlined,
                        onPressed: () => _abrirTela(
                          context,
                          const CustoPorUsoScreen(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _BotaoCalculadora(
                        texto: 'Juros compostos',
                        icone: Icons.trending_up,
                        onPressed: () => _abrirTela(
                          context,
                          const JurosCompostosScreen(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _BotaoCalculadora(
                        texto: 'Imposto sobre compra internacional',
                        icone: Icons.public,
                        onPressed: () => _abrirTela(
                          context,
                          const ImpostoSobreCompraScreen(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BotaoCalculadora extends StatelessWidget {
  const _BotaoCalculadora({
    required this.texto,
    required this.icone,
    required this.onPressed,
  });

  final String texto;
  final IconData icone;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone),
        label: Text(texto, textAlign: TextAlign.center),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}