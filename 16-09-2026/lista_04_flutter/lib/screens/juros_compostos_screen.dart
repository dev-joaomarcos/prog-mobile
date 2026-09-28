import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/resultado_juros_compostos.dart';

class JurosCompostosScreen extends StatefulWidget {
  const JurosCompostosScreen({super.key});

  @override
  State<JurosCompostosScreen> createState() => _JurosCompostosScreenState();
}

class _JurosCompostosScreenState extends State<JurosCompostosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _capitalController = TextEditingController();
  final _taxaController = TextEditingController();
  final _mesesController = TextEditingController();

  ResultadoJurosCompostos? _resultado;

  final NumberFormat _moeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void dispose() {
    _capitalController.dispose();
    _taxaController.dispose();
    _mesesController.dispose();
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

  String? _validarMeses(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Preencha este campo';
    }
    if (int.tryParse(valor.trim()) == null) {
      return 'Digite um número inteiro válido';
    }
    if (int.parse(valor.trim()) < 0) {
      return 'O número de meses não pode ser negativo';
    }
    return null;
  }

  void _calcularJurosCompostos() {
    if (!_formKey.currentState!.validate()) return;

    final capital = _lerNumero(_capitalController.text)!;
    final taxa = _lerNumero(_taxaController.text)!;
    final meses = int.parse(_mesesController.text.trim());

    final montante = capital * pow(1 + taxa / 100, meses);

    setState(() {
      _resultado = ResultadoJurosCompostos(
        montante: montante.toDouble(),
        jurosGanhos: montante - capital,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de juros compostos')),
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
                          'Calcular juros compostos',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _capitalController,
                          decoration: const InputDecoration(
                            labelText: 'Capital inicial (R\$)',
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
                          controller: _taxaController,
                          decoration: const InputDecoration(
                            labelText: 'Taxa de juros ao mês (%)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.percent),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _validarNumero,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mesesController,
                          decoration: const InputDecoration(
                            labelText: 'Número de meses',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_month),
                          ),
                          keyboardType: TextInputType.number,
                          validator: _validarMeses,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _calcularJurosCompostos,
                          child: const Text('Calcular'),
                        ),
                        if (_resultado != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Montante final: '
                            '${_moeda.format(_resultado!.montante)}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Juros ganhos: '
                            '${_moeda.format(_resultado!.jurosGanhos)}',
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