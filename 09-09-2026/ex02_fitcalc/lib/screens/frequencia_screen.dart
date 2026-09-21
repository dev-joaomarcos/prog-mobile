import 'package:flutter/material.dart';

class FrequenciaScreen extends StatefulWidget {
  const FrequenciaScreen({super.key});

  @override
  State<FrequenciaScreen> createState() => _FrequenciaScreenState();
}

class _FrequenciaScreenState extends State<FrequenciaScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idadeController = TextEditingController();

  String _resultado = '';

  @override
  void dispose() {
    _idadeController.dispose();
    super.dispose();
  }

  void _calcularFrequencia() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int idade = int.parse(_idadeController.text);

    // Fórmula de exemplo.
    final int frequenciaMaxima = 220 - idade;

    setState(() {
      _resultado = 'Frequência cardíaca máxima: $frequenciaMaxima bpm';
    });
  }

  String? _validarIdade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe sua idade';
    }

    final idade = int.tryParse(value);

    if (idade == null || idade <= 0) {
      return 'Informe uma idade válida';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequência Cardíaca'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                ),
                validator: _validarIdade,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _calcularFrequencia,
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
