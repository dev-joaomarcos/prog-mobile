import 'package:flutter/material.dart';
//Tem que usar essa biblioteca para algumas operacoes e a constante do Pi
import 'dart:math' as math;
//HAHA!!! ERA SÓ IMPORTAR O MODEL, EU PASSEI TEMPO DEMAIS PRA DESCOBRIR ISSO.
import 'package:atividade04/models/model_poligono.dart';

// ============================================================================
// TELA
// ============================================================================
class TelaQuadradoScreen extends StatefulWidget {
  const TelaQuadradoScreen({super.key});
 
  @override
  State<TelaQuadradoScreen> createState() => _TelaQuadradoScreenScreenState();
}
 
class _TelaQuadradoScreenScreenState extends State<TelaQuadradoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _ladoController = TextEditingController();
 
  ResultadoQuadrado? _resultado;

  void _calcularArea() {
    if (!_formKey.currentState!.validate()) return;
 
    final lado = double.parse(_ladoController.text.replaceAll(',', '.'));
    //Só fiz isso pra ficar bonito, creio que tanto faz kkkkk
    final area = math.pow(lado, 2);
 
    setState(() {
      _resultado = ResultadoQuadrado(
        lado: lado,
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
    _ladoController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Área do Quadrado')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'A = L²',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ladoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Lado (L)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.square_foot),
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
 
  Widget _buildResultado(ResultadoQuadrado r) {
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
