import 'package:flutter/material.dart';

class PassosScreen extends StatefulWidget {
  const PassosScreen({super.key});

  @override
  State<PassosScreen> createState() => _PassosScreenState();
}

class _PassosScreenState extends State<PassosScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passosController = TextEditingController();

  String _resultado = '';

  @override
  void dispose() {
    _passosController.dispose();
    super.dispose();
  }

  void _calcularMeta() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int passos = int.parse(_passosController.text);

    // Meta de exemplo.
    const int meta = 10000;

    final int restantes = meta - passos;

    setState(() {
      if (restantes > 0) {
        _resultado = 'Faltam $restantes passos para atingir a meta de $meta.';
      } else {
        _resultado = 'Meta de $meta passos atingida!';
      }
    });
  }

  String? _validarPassos(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe a quantidade de passos';
    }

    final passos = int.tryParse(value);

    if (passos == null || passos < 0) {
      return 'Informe uma quantidade válida';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meta de Passos'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _passosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Passos realizados',
                  border: OutlineInputBorder(),
                ),
                validator: _validarPassos,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _calcularMeta,
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
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
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
