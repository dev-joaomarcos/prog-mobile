import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/resultado_custo.dart';

class CustoScreen extends StatefulWidget {
  const CustoScreen({super.key});

  @override
  State<CustoScreen> createState() => _CustoScreenState();
}

class _CustoScreenState extends State<CustoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _distanciaController = TextEditingController();
  final _consumoController = TextEditingController();
  final _precoController = TextEditingController();

  ResultadoCusto? _resultado;
  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  void _calcularCusto() {
    if (!_formKey.currentState!.validate()) return;

    final distancia = double.parse(_distanciaController.text.replaceAll(',', '.'));
    final consumoMedio = double.parse(_consumoController.text.replaceAll(',', '.'));
    final precoLitro = double.parse(_precoController.text.replaceAll(',', '.'));
    final litrosNecessarios = distancia / consumoMedio;
    final custoTotal = litrosNecessarios * precoLitro;

    setState(() {
      _resultado = ResultadoCusto(
        distancia: distancia,
        consumoMedio: consumoMedio,
        precoLitro: precoLitro,
        litrosNecessarios: double.parse(litrosNecessarios.toStringAsFixed(2)),
        custoTotal: double.parse(custoTotal.toStringAsFixed(2)),
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
    _distanciaController.dispose();
    _consumoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custo da Viagem')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _distanciaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Distância da viagem (km)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.route_outlined),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _consumoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Consumo médio do carro (km/l)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_gas_station_outlined),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Preço do litro (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularCusto,
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

  Widget _buildResultado(ResultadoCusto r) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _linha('Litros necessários', '${r.litrosNecessarios.toStringAsFixed(2)} L'),
            const Divider(),
            _linha('Custo total', _formatoMoeda.format(r.custoTotal), destaque: true),
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
          Text(rotulo, style: destaque ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: destaque ? Colors.blueGrey : null,
              fontSize: destaque ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
