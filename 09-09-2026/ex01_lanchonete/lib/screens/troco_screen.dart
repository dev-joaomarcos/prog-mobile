import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/resultado_troco.dart';

// ============================================================================
// TELA
// ============================================================================
class TrocoScreen extends StatefulWidget {
  const TrocoScreen({super.key});

  @override
  State<TrocoScreen> createState() => _TrocoScreenState();
}

class _TrocoScreenState extends State<TrocoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _compraController = TextEditingController();
  final _pagoController = TextEditingController();

  ResultadoTroco? _resultado;

  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  /// Troco = valor pago - valor da compra.
  void _calcularTroco() {
    if (!_formKey.currentState!.validate()) return;

    final valorCompra = double.parse(
      _compraController.text.replaceAll(',', '.'),
    );
    final valorPago = double.parse(_pagoController.text.replaceAll(',', '.'));

    final diferenca = valorPago - valorCompra;
    final insuficiente = diferenca < 0;

    setState(() {
      _resultado = ResultadoTroco(
        valorCompra: valorCompra,
        valorPago: valorPago,
        troco: double.parse((insuficiente ? 0 : diferenca).toStringAsFixed(2)),
        valorInsuficiente: insuficiente,
      );
    });
  }

  String? _validarValor(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe um valor';
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null || numero <= 0)
      return 'Informe um valor numérico válido';
    return null;
  }

  @override
  void dispose() {
    _compraController.dispose();
    _pagoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Troco')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _compraController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Valor total da compra (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.receipt_long),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pagoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Valor pago pelo cliente (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularTroco,
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

  Widget _buildResultado(ResultadoTroco r) {
    if (r.valorInsuficiente) {
      return Card(
        color: Colors.red.shade50,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Valor pago insuficiente! Faltam ${_formatoMoeda.format(r.valorCompra - r.valorPago)}.',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultado',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Troco'),
                Text(
                  _formatoMoeda.format(r.troco),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
