import 'package:flutter/material.dart';
import '../models/resultado_dias_restantes.dart';

class DiasRestantesScreen extends StatefulWidget {
  const DiasRestantesScreen({super.key});

  @override
  State<DiasRestantesScreen> createState() => _DiasRestantesScreenState();
}

class _DiasRestantesScreenState extends State<DiasRestantesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diasPassadosController = TextEditingController();
  final _prazoController = TextEditingController(text: '14');

  ResultadoDiasRestantes? _resultado;

  void _calcularDiasRestantes() {
    if (!_formKey.currentState!.validate()) return;

    final diasPassados = int.parse(_diasPassadosController.text);
    final prazo = int.parse(_prazoController.text);
    final diasRestantes = prazo - diasPassados;

    setState(() {
      _resultado = ResultadoDiasRestantes(
        diasPassados: diasPassados,
        prazoEmprestimo: prazo,
        diasRestantes: diasRestantes,
        atrasado: diasRestantes < 0,
      );
    });
  }

  String? _validarInteiro(String? valor, String mensagem) {
    if (valor == null || valor.isEmpty) return mensagem;
    final numero = int.tryParse(valor);
    if (numero == null || numero < 0) return 'Informe um número inteiro válido';
    return null;
  }

  @override
  void dispose() {
    _diasPassadosController.dispose();
    _prazoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dias Restantes')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _diasPassadosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Dias passados desde o empréstimo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: (v) => _validarInteiro(v, 'Informe os dias passados'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prazoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Prazo padrão de empréstimo (dias)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.menu_book_outlined),
                ),
                validator: (v) => _validarInteiro(v, 'Informe o prazo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularDiasRestantes,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Calcular', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
              if (_resultado != null) _buildResultado(_resultado!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultado(ResultadoDiasRestantes r) {
    if (r.atrasado) {
      return Card(
        color: Colors.red.shade50,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Atrasado há ${r.diasRestantes.abs()} dias',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
    }
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _linha('Dias restantes', '${r.diasRestantes}', destaque: true),
          ],
        ),
      ),
    );
  }

  Widget _linha(String rotulo, String valor, {bool destaque = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(rotulo, style: destaque ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: destaque ? Colors.brown : null,
              fontSize: destaque ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
