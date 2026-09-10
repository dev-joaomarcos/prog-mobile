import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/resultado_Passos.dart';

// ============================================================================
// TELA
// ============================================================================
class PassosScreen extends StatefulWidget {
  const PassosScreen({super.key});

  @override
  State<PassosScreen> createState() => _PassosScreenState();
}

class _PassosScreenState extends State<PassosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantidadeController = TextEditingController();
  final _precoController = TextEditingController();
  final _taxaController = TextEditingController(text: '0');

  ResultadoPassos? _resultado;

  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');


  void _calcularPassos() {
    if (!_formKey.currentState!.validate()) return;

    final quantidade = int.parse(_quantidadeController.text);
    final precoUnitario = double.parse(
      _precoController.text.replaceAll(',', '.'),
    );
    final taxaEntrega = double.parse(_taxaController.text.replaceAll(',', '.'));

    final subtotal = quantidade * precoUnitario;
    final total = subtotal + taxaEntrega;

    setState(() {
      _resultado = ResultadoPassos(
        quantidade: quantidade,
        precoUnitario: precoUnitario,
        taxaEntrega: taxaEntrega,
        subtotal: double.parse(subtotal.toStringAsFixed(2)),
        total: double.parse(total.toStringAsFixed(2)),
      );
    });
  }

  String? _validarInteiro(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe a quantidade';
    final numero = int.tryParse(valor);
    if (numero == null || numero <= 0)
      return 'Informe um número inteiro válido';
    return null;
  }

  String? _validarValor(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe um valor';
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null || numero < 0) return 'Informe um valor numérico válido';
    return null;
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    _precoController.dispose();
    _taxaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Total do Passos')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade de itens',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: _validarInteiro,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Preço unitário (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taxaController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Taxa de entrega (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.delivery_dining),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularPassos,
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

  Widget _buildResultado(ResultadoPassos r) {
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
              'Subtotal (${r.quantidade} x ${_formatoMoeda.format(r.precoUnitario)})',
              _formatoMoeda.format(r.subtotal),
            ),
            _linha('Taxa de entrega', _formatoMoeda.format(r.taxaEntrega)),
            const Divider(),
            _linha(
              'Total do Passos',
              _formatoMoeda.format(r.total),
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
