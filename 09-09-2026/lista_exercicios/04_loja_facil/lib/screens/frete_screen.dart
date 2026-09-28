import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/resultado_frete.dart';

class FreteScreen extends StatefulWidget {
  const FreteScreen({super.key});

  @override
  State<FreteScreen> createState() => _FreteScreenState();
}

class _FreteScreenState extends State<FreteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _compraController = TextEditingController();
  final _minimoController = TextEditingController();

  ResultadoFrete? _resultado;
  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  void _calcularFrete() {
    if (!_formKey.currentState!.validate()) return;

    final valorCompra = double.parse(_compraController.text.replaceAll(',', '.'));
    final valorMinimo = double.parse(_minimoController.text.replaceAll(',', '.'));
    final freteGratis = valorCompra >= valorMinimo;
    final faltante = freteGratis ? 0.0 : valorMinimo - valorCompra;

    setState(() {
      _resultado = ResultadoFrete(
        valorCompra: valorCompra,
        valorMinimo: valorMinimo,
        freteGratis: freteGratis,
        valorFaltante: double.parse(faltante.toStringAsFixed(2)),
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
    _compraController.dispose();
    _minimoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frete Grátis')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _compraController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor da compra (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_cart_outlined),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _minimoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor mínimo para frete grátis (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_shipping_outlined),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularFrete,
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

  Widget _buildResultado(ResultadoFrete r) {
    if (r.freteGratis) {
      return Card(
        color: Colors.green.shade50,
        elevation: 3,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Frete grátis liberado!',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
    }
    return Card(
      color: Colors.orange.shade50,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Faltam ${_formatoMoeda.format(r.valorFaltante)} para o frete grátis.',
          style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
