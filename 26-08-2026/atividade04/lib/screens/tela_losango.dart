import 'package:flutter/material.dart';
//HAHA!!! ERA SÓ IMPORTAR O MODEL, EU PASSEI TEMPO DEMAIS PRA DESCOBRIR ISSO.
import 'package:atividade04/models/model_poligono.dart';
// ============================================================================
// TELA
// ============================================================================
class TelaLosangoScreen extends StatefulWidget {
  const TelaLosangoScreen({super.key});
 
  @override
  State<TelaLosangoScreen> createState() => _TelaLosangoScreenScreenState();
}
 
class _TelaLosangoScreenScreenState extends State<TelaLosangoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _diagonalMaiorController = TextEditingController();
  final _diagonalMenorController = TextEditingController();
 
  ResultadoLosango? _resultado;

  void _calcularArea() {
    if (!_formKey.currentState!.validate()) return;
 
    final diagonalMaior = double.parse(_diagonalMaiorController.text.replaceAll(',', '.'));
    final diagonalMenor = double.parse(_diagonalMenorController.text.replaceAll(',', '.'));
 
    final area = (diagonalMaior * diagonalMenor) / 2;
 
    setState(() {
      _resultado = ResultadoLosango(
        diagonalMaior: diagonalMaior,
        diagonalMenor: diagonalMenor,
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
    _diagonalMaiorController.dispose();
    _diagonalMenorController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Área do Losango')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'A = (D . d) / 2',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _diagonalMaiorController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Diagonal Maior (D)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
                ),
                validator: _validarNumero,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diagonalMenorController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Diagonal Menor (d)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
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
 
  Widget _buildResultado(ResultadoLosango r) {
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
