import 'package:flutter/material.dart';
import '../models/resultado_fcm.dart';

class FcmScreen extends StatefulWidget {
  const FcmScreen({super.key});

  @override
  State<FcmScreen> createState() => _FcmScreenState();
}

class _FcmScreenState extends State<FcmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idadeController = TextEditingController();

  ResultadoFcm? _resultado;

  void _calcularFcm() {
    if (!_formKey.currentState!.validate()) return;

    final idade = int.parse(_idadeController.text);
    final fcm = 220 - idade;
    final zonaMinima = fcm * 0.5;
    final zonaMaxima = fcm * 0.85;

    setState(() {
      _resultado = ResultadoFcm(
        idade: idade,
        fcm: fcm.toDouble(),
        zonaMinima: double.parse(zonaMinima.toStringAsFixed(0)),
        zonaMaxima: double.parse(zonaMaxima.toStringAsFixed(0)),
      );
    });
  }

  String? _validarInteiro(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe a idade';
    final numero = int.tryParse(valor);
    if (numero == null || numero <= 0) return 'Informe um número inteiro válido';
    return null;
  }

  @override
  void dispose() {
    _idadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frequência Cardíaca Máxima')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
                validator: _validarInteiro,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularFcm,
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

  Widget _buildResultado(ResultadoFcm r) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _linha('FCM', '${r.fcm.toStringAsFixed(0)} bpm', destaque: true),
            const Divider(),
            _linha('Zona de treino (mín. 50%)', '${r.zonaMinima.toStringAsFixed(0)} bpm'),
            _linha('Zona de treino (máx. 85%)', '${r.zonaMaxima.toStringAsFixed(0)} bpm'),
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
              color: destaque ? Colors.teal : null,
              fontSize: destaque ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
