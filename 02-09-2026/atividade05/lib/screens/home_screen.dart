import 'package:flutter/material.dart';
import 'inss_screen.dart';
import 'ir_screen.dart';
import 'fgts_screen.dart';

/// Tela inicial: apenas um menu com botões que navegam para cada calculadora.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Trabalhista'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calculate_outlined, size: 72, color: Colors.blue),
              const SizedBox(height: 12),
              const Text(
                'Selecione o cálculo desejado',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
 
              _BotaoMenu(
                titulo: 'Calcular INSS',
                icone: Icons.account_balance_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InssScreen()),
                ),
              ),
              const SizedBox(height: 16),
 
              _BotaoMenu(
                titulo: 'Calcular Imposto de Renda (IR)',
                icone: Icons.receipt_long_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IrScreen()),
                ),
              ),
              const SizedBox(height: 16),
 
              _BotaoMenu(
                titulo: 'Calcular FGTS',
                icone: Icons.savings_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FgtsScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
/// Widget reutilizável para não repetir o mesmo botão 3 vezes.
class _BotaoMenu extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback onTap;
 
  const _BotaoMenu({
    required this.titulo,
    required this.icone,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icone),
        label: Text(titulo, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
