import 'package:flutter/material.dart';
import '../models/resultado_tempo.dart';

class TempoScreen extends StatefulWidget {
  const TempoScreen({super.key});

  @override
  State<TempoScreen> createState() => _TempoScreenState();
}

class _TempoScreenState extends State<TempoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _distanciaController = TextEditingController();
  final _velocidadeController = TextEditingController();

  ResultadoTempo? _resultado;

  void _calcularTempo() {
    if (!_formKey.currentState!.validate()) return;

    final distancia = double.parse(_distanciaController.text.replaceAll(',', '.'));
    final velocidade = double.parse(_velocidadeController.text.replaceAll(',', '.'));
    final horasDecimais = distancia / velocidade;
    final horas = horasDecimais.floor();
    final minutos = ((horasDecimais - horas) * 60).round();

    setState(() {
      _resultado = ResultadoTempo(
        distancia: distancia,
        velocidade: velocidade,
        horasDecimais: double.parse(horasDecimais.toStringAsFixed(2)),
        horas: horas,
        minutos: minutos,
      );
    });
  }

  String? _validarValor(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe um valor';
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null || numero <= 0) return 'Informe um valor numérico válido';
    return null;
  }

  @override
  void dispose() {
    _distanciaController.dispose();
    _velocidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tempo de Viagem')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _distanciaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Distância (km)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.route_outlined),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _velocidadeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Velocidade média (km/h)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.speed_outlined),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularTempo,
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

  Widget _buildResultado(ResultadoTempo r) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _linha('Tempo estimado', '${r.horas}h ${r.minutos}min', destaque: true),
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
              color: destaque ? Colors.blueGrey : null,
              fontSize: destaque ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
