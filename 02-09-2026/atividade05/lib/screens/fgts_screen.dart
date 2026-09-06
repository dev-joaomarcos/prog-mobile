import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 
// ============================================================================
// MODELO — guarda apenas os dados de entrada/saída deste cálculo.
// ============================================================================
class ResultadoFgts {
  final double salarioBruto;
  final double aliquota;
  final double valorDeposito;
 
  ResultadoFgts({
    required this.salarioBruto,
    required this.aliquota,
    required this.valorDeposito,
  });
}
 
// ============================================================================
// TELA
// ============================================================================
class FgtsScreen extends StatefulWidget {
  const FgtsScreen({super.key});
 
  @override
  State<FgtsScreen> createState() => _FgtsScreenState();
}
 
class _FgtsScreenState extends State<FgtsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salarioController = TextEditingController();
 
  bool _ehAprendiz = false;
  ResultadoFgts? _resultado;
 
  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
 
  /// Calcula o depósito mensal de FGTS (feito pelo empregador, não é
  /// descontado do funcionário).
  void _calcularFgts() {
    if (!_formKey.currentState!.validate()) return;
 
    final salarioBruto = double.parse(_salarioController.text.replaceAll(',', '.'));
    final aliquota = _ehAprendiz ? 0.02 : 0.08;
    final valorDeposito = double.parse((salarioBruto * aliquota).toStringAsFixed(2));
 
    setState(() {
      _resultado = ResultadoFgts(
        salarioBruto: salarioBruto,
        aliquota: aliquota,
        valorDeposito: valorDeposito,
      );
    });
  }
 
  @override
  void dispose() {
    _salarioController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular FGTS')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _salarioController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Salário bruto (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Informe o salário bruto';
                  }
                  final numero = double.tryParse(valor.replaceAll(',', '.'));
                  if (numero == null || numero <= 0) {
                    return 'Informe um valor numérico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Contrato de aprendiz (2%)'),
                subtitle: const Text('Desligado = alíquota padrão de 8%'),
                value: _ehAprendiz,
                onChanged: (valor) => setState(() => _ehAprendiz = valor),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _calcularFgts,
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
 
  Widget _buildResultado(ResultadoFgts r) {
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
                Text('Depósito mensal de FGTS (${(r.aliquota * 100).toStringAsFixed(0)}%)'),
                Text(
                  _formatoMoeda.format(r.valorDeposito),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Obs.: o FGTS é depositado pelo empregador em conta vinculada '
              'e não é descontado do salário do funcionário.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
