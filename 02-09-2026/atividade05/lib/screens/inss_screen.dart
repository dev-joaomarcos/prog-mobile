import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 
// ============================================================================
// MODELO — guarda apenas os dados de entrada/saída deste cálculo.
// ============================================================================
class ResultadoInss {
  final double salarioBruto;
  final double valorDescontado;
  final double aliquotaEfetiva;
  final double salarioLiquido;
 
  ResultadoInss({
    required this.salarioBruto,
    required this.valorDescontado,
    required this.aliquotaEfetiva,
    required this.salarioLiquido,
  });
}
 
// ============================================================================
// TELA
// ============================================================================
class InssScreen extends StatefulWidget {
  const InssScreen({super.key});
 
  @override
  State<InssScreen> createState() => _InssScreenState();
}
 
class _InssScreenState extends State<InssScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salarioController = TextEditingController();
 
  ResultadoInss? _resultado;
 
  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
 
  // Teto de contribuição do INSS 2026.
  static const double _tetoInss = 8475.55;
 
  /// Calcula o desconto de INSS (empregado CLT) sobre o salário digitado.
  /// Tabela vigente a partir de janeiro/2026.
  void _calcularInss() {
    if (!_formKey.currentState!.validate()) return;
 
    final salarioBruto = double.parse(_salarioController.text.replaceAll(',', '.'));
 
    // O desconto nunca incide sobre a parte do salário acima do teto.
    final base = salarioBruto > _tetoInss ? _tetoInss : salarioBruto;
 
    double valorDescontado;
    if (base <= 1621.00) {
      valorDescontado = base * 0.075;
    } else if (base <= 2902.84) {
      valorDescontado = (base * 0.09) - 24.32;
    } else if (base <= 4354.27) {
      valorDescontado = (base * 0.12) - 111.40;
    } else {
      valorDescontado = (base * 0.14) - 198.49;
    }
    valorDescontado = double.parse(valorDescontado.toStringAsFixed(2));
 
    final aliquotaEfetiva = double.parse(
      ((valorDescontado / salarioBruto) * 100).toStringAsFixed(2),
    );
    final salarioLiquido = double.parse(
      (salarioBruto - valorDescontado).toStringAsFixed(2),
    );
 
    setState(() {
      _resultado = ResultadoInss(
        salarioBruto: salarioBruto,
        valorDescontado: valorDescontado,
        aliquotaEfetiva: aliquotaEfetiva,
        salarioLiquido: salarioLiquido,
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
      appBar: AppBar(title: const Text('Calcular INSS')),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularInss,
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
 
  Widget _buildResultado(ResultadoInss r) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _linha('Salário bruto', _formatoMoeda.format(r.salarioBruto)),
            _linha('Desconto de INSS', _formatoMoeda.format(r.valorDescontado)),
            _linha('Alíquota efetiva', '${r.aliquotaEfetiva}%'),
            _linha('Salário líquido (só INSS)', _formatoMoeda.format(r.salarioLiquido)),
          ],
        ),
      ),
    );
  }
 
  Widget _linha(String rotulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(rotulo),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
 
