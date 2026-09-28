import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/resultado_custo_por_uso.dart';

class CustoPorUsoScreen extends StatefulWidget {
  const CustoPorUsoScreen({super.key});

  @override
  State<CustoPorUsoScreen> createState() => _CustoPorUsoScreenState();
}

class _CustoPorUsoScreenState extends State<CustoPorUsoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _precoController = TextEditingController();
  final _usosController = TextEditingController();

  ResultadoCustoPorUso? _resultado;

  final NumberFormat _moeda = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  @override
  void dispose() {
    _precoController.dispose();
    _usosController.dispose();
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

  String? _validarUsos(String? valor) {
    final erro = _validarNumero(valor);
    if (erro != null) return erro;

    final usos = _lerNumero(valor)!;
    if (usos <= 0) return 'O número de usos deve ser maior que zero';

    return null;
  }

  void _calcularCustoPorUso() {
    if (!_formKey.currentState!.validate()) return;

    final preco = _lerNumero(_precoController.text)!;
    final usos = _lerNumero(_usosController.text)!;

    setState(() {
      _resultado = ResultadoCustoPorUso(custoPorUso: preco / usos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custo por uso de produto')),
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
                          'Calcular custo por uso',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _precoController,
                          decoration: const InputDecoration(
                            labelText: 'Preço do produto (R\$)',
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
                          controller: _usosController,
                          decoration: const InputDecoration(
                            labelText: 'Número de usos previstos',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.repeat),
                          ),
                          keyboardType: TextInputType.number,
                          validator: _validarUsos,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _calcularCustoPorUso,
                          child: const Text('Calcular'),
                        ),
                        if (_resultado != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Custo estimado por uso: '
                            '${_moeda.format(_resultado!.custoPorUso)}',
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
