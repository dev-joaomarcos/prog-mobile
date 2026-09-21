import 'package:flutter/material.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  String _resultado = '';

  @override
  void dispose() {
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  void _calcularImc() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double peso = double.parse(_pesoController.text.replaceAll(',', '.'));

    final double altura = double.parse(
      _alturaController.text.replaceAll(',', '.'),
    );

    final double imc = peso / (altura * altura);

    setState(() {
      _resultado = 'IMC: ${imc.toStringAsFixed(2)}';
    });
  }

  String? _validarNumero(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe um valor';
    }

    final numero = double.tryParse(value.replaceAll(',', '.'));

    if (numero == null || numero <= 0) {
      return 'Informe um número válido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: _validarNumero,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _alturaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Altura (m)',
                  border: OutlineInputBorder(),
                ),
                validator: _validarNumero,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _calcularImc,
                  child: const Text('Calcular'),
                ),
              ),

              const SizedBox(height: 24),

              if (_resultado.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _resultado,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
