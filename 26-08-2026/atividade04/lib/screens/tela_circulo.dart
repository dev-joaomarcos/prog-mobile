import 'package:flutter/material.dart';
//Tem que usar essa biblioteca para algumas operacoes e a constante do Pi
import 'dart:math' as math;
//HAHA!!! ERA SÓ IMPORTAR O MODEL, EU PASSEI TEMPO DEMAIS PRA DESCOBRIR ISSO.
import 'package:atividade04/models/model_poligono.dart';
// ============================================================================
// TELA
// ============================================================================
class TelaCirculoScreen extends StatefulWidget {
  const TelaCirculoScreen({super.key});
 
  @override
  State<TelaCirculoScreen> createState() => _TelaCirculoScreenScreenState();
}
 class _TelaCirculoScreenScreenState extends State<TelaCirculoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _raioController = TextEditingController();

  ResultadoCirculo? _resultado;
 
  void _calcularArea() {
    if (!_formKey.currentState!.validate()) return;
 
    final raio = double.parse(_raioController.text.replaceAll(',', '.'));
    final pi = math.pi;
    //Math.pow só pra não ter que usar operador de prioridade
    final area = pi * math.pow(raio, 2);
 
    setState(() {
      _resultado = ResultadoCirculo(
        raio: raio,
        area: double.parse(area.toStringAsFixed(2)),
      );
    });
  }
 
  String? _validarNumero(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe um valor';
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null || numero <= 0) return 'Informe um valor numérico válido';
    return null;
  }
 
  @override
  void dispose() {
    _raioController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Área do Círculo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'A = π . r²',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _raioController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Raio (r)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.track_changes),
                ),
                validator: _validarNumero,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularArea,
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
 
  Widget _buildResultado(ResultadoCirculo r) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Área'),
                Text(
                  '${r.area} un²',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
