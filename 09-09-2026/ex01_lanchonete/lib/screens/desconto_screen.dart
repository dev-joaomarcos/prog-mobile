import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/resultado_desconto.dart';

// ============================================================================
// TELA
// ============================================================================
class DescontoScreen extends StatefulWidget {
  const DescontoScreen({super.key});

  @override
  State<DescontoScreen> createState() => _DescontoScreenState();
}

class _DescontoScreenState extends State<DescontoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  final _percentualController = TextEditingController();

  ResultadoDesconto? _resultado;

  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  /// Valor do desconto = valor da compra x (percentual / 100).
  void _calcularDesconto() {
    if (!_formKey.currentState!.validate()) return;

    final valorCompra = double.parse(
      _valorController.text.replaceAll(',', '.'),
    );
    final percentual = double.parse(
      _percentualController.text.replaceAll(',', '.'),
    );

    final valorDesconto = valorCompra * (percentual / 100);
    final valorFinal = valorCompra - valorDesconto;

    setState(() {
      _resultado = ResultadoDesconto(
        valorCompra: valorCompra,
        percentual: percentual,
        valorDesconto: double.parse(valorDesconto.toStringAsFixed(2)),
        valorFinal: double.parse(valorFinal.toStringAsFixed(2)),
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

  String? _validarPercentual(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe um percentual';
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null || numero <= 0 || numero > 100)
      return 'Informe um valor entre 0 e 100';
    return null;
  }

  @override
  void dispose() {
    _valorController.dispose();
    _percentualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Desconto')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _valorController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Valor da compra (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _percentualController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Percentual de desconto (%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.percent),
                ),
                validator: _validarPercentual,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularDesconto,
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

  Widget _buildResultado(ResultadoDesconto r) {
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
            _linha(
              'Valor do desconto (${r.percentual.toStringAsFixed(0)}%)',
              '- ${_formatoMoeda.format(r.valorDesconto)}',
            ),
            const Divider(),
            _linha(
              'Valor final',
              _formatoMoeda.format(r.valorFinal),
              destaque: true,
            ),
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
          Text(
            rotulo,
            style: destaque
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: destaque ? Colors.deepOrange : null,
              fontSize: destaque ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
