import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/resultado_imposto_sobre_compra.dart';

class ImpostoSobreCompraScreen extends StatefulWidget {
  const ImpostoSobreCompraScreen({super.key});

  @override
  State<ImpostoSobreCompraScreen> createState() =>
      _ImpostoSobreCompraScreenState();
}

class _ImpostoSobreCompraScreenState
    extends State<ImpostoSobreCompraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dolarController = TextEditingController();
  final _cotacaoController = TextEditingController();
  final _percentualController = TextEditingController();

  ResultadoImpostoSobreCompra? _resultado;

  final NumberFormat _moeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void dispose() {
    _dolarController.dispose();
    _cotacaoController.dispose();
    _percentualController.dispose();
    super.dispose();
  }

  double? _lerNumero(String? valor) {
    if (valor == null || valor.trim().isEmpty) return null;
    return double.tryParse(valor.trim().replaceAll(',', '.'));
  }

  String? _validarNumero(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Preencha este campo';
    }
    if (_lerNumero(valor) == null) {
      return 'Digite um número válido';
    }
    return null;
  }

  void _calcularImposto() {
    if (!_formKey.currentState!.validate()) return;

    final valorDolar = _lerNumero(_dolarController.text)!;
    final cotacao = _lerNumero(_cotacaoController.text)!;
    final percentual = _lerNumero(_percentualController.text)!;

    final valorEmReais = valorDolar * cotacao;
    final imposto = valorEmReais * (percentual / 100);

    setState(() {
      _resultado = ResultadoImpostoSobreCompra(
        valorEmReais: valorEmReais,
        imposto: imposto,
        valorFinal: valorEmReais + imposto,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imposto sobre compra internacional')),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                color: Colors.white,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Compra internacional',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _dolarController,
                          decoration: const InputDecoration(
                            labelText: 'Valor da compra (US\$)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _validarNumero,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cotacaoController,
                          decoration: const InputDecoration(
                            labelText: 'Cotação do dólar (R\$)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.currency_exchange),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _validarNumero,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _percentualController,
                          decoration: const InputDecoration(
                            labelText: 'Percentual de imposto (%)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.percent),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _validarNumero,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _calcularImposto,
                          child: const Text('Calcular'),
                        ),
                        if (_resultado != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Valor sem imposto: '
                            '${_moeda.format(_resultado!.valorEmReais)}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Imposto: ${_moeda.format(_resultado!.imposto)}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Valor final: '
                            '${_moeda.format(_resultado!.valorFinal)}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}