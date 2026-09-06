import 'package:flutter/material.dart';
//HAHA!!! ERA SÓ IMPORTAR O MODEL, EU PASSEI TEMPO DEMAIS PRA DESCOBRIR ISSO.
import 'package:atividade04/models/model_poligono.dart';

class TelaRetanguloScreen extends StatefulWidget {
  const TelaRetanguloScreen({super.key});
 
  @override
  State<TelaRetanguloScreen> createState() => _TelaRetanguloScreenScreenState();
}
 
class _TelaRetanguloScreenScreenState extends State<TelaRetanguloScreen> {
  final _formKey = GlobalKey<FormState>();

  final _baseController = TextEditingController();
  final _alturaController = TextEditingController();
 
  ResultadoRetangulo? _resultado;
 
  void _calcularArea() {
    if (!_formKey.currentState!.validate()) return;
 
    final base = double.parse(_baseController.text.replaceAll(',', '.'));
    final altura = double.parse(_alturaController.text.replaceAll(',', '.'));
 
    final area = base * altura;
 
    setState(() {
      _resultado = ResultadoRetangulo(
        base: base,
        altura: altura,
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
    _baseController.dispose();
    _alturaController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Área do Retângulo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'A = b . h',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _baseController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Base (b)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
                validator: _validarNumero,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alturaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Altura (h)',
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
 
  Widget _buildResultado(ResultadoRetangulo r) {
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
