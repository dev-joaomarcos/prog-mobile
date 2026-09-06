import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 
// ============================================================================
// MODELO — guarda apenas os dados de entrada/saída deste cálculo.
// ============================================================================
class ResultadoIr {
  final double inssDescontado;
  final double baseDeCalculo;
  final double impostoAntesDoRedutor;
  final double valorDoRedutor;
  final double valorFinal;
 
  ResultadoIr({
    required this.inssDescontado,
    required this.baseDeCalculo,
    required this.impostoAntesDoRedutor,
    required this.valorDoRedutor,
    required this.valorFinal,
  });
}
 
// ============================================================================
// TELA
// ============================================================================
class IrScreen extends StatefulWidget {
  const IrScreen({super.key});
 
  @override
  State<IrScreen> createState() => _IrScreenState();
}
 
class _IrScreenState extends State<IrScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salarioController = TextEditingController();
  final _dependentesController = TextEditingController(text: '0');
 
  ResultadoIr? _resultado;
 
  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
 
  // Constantes vigentes a partir de janeiro/2026.
  static const double _tetoInss = 8475.55;
  static const double _deducaoPorDependente = 189.59;
 
  /// Desconto de INSS — precisa ser calculado antes do IR, pois entra
  /// como dedução na base de cálculo do imposto.
  double _calcularInss(double salarioBruto) {
    final base = salarioBruto > _tetoInss ? _tetoInss : salarioBruto;
 
    double valor;
    if (base <= 1621.00) {
      valor = base * 0.075;
    } else if (base <= 2902.84) {
      valor = (base * 0.09) - 24.32;
    } else if (base <= 4354.27) {
      valor = (base * 0.12) - 111.40;
    } else {
      valor = (base * 0.14) - 198.49;
    }
    return double.parse(valor.toStringAsFixed(2));
  }
 
  /// Calcula o IRRF mensal, já considerando o redutor da Lei 15.270/2025.
  void _calcularIr() {
    if (!_formKey.currentState!.validate()) return;
 
    final salarioBruto = double.parse(_salarioController.text.replaceAll(',', '.'));
    final dependentes = int.parse(_dependentesController.text);
 
    final inss = _calcularInss(salarioBruto);
 
    // Isenção total: rendimento bruto até R$ 5.000,00.
    if (salarioBruto <= 5000.00) {
      setState(() {
        _resultado = ResultadoIr(
          inssDescontado: inss,
          baseDeCalculo: 0,
          impostoAntesDoRedutor: 0,
          valorDoRedutor: 0,
          valorFinal: 0,
        );
      });
      return;
    }
 
    // Base de cálculo = salário bruto - INSS - (dependentes x dedução).
    double base = salarioBruto - inss - (dependentes * _deducaoPorDependente);
    if (base < 0) base = 0;
 
    // Tabela progressiva tradicional.
    double impostoApurado;
    if (base <= 2428.80) {
      impostoApurado = 0;
    } else if (base <= 2826.65) {
      impostoApurado = (base * 0.075) - 182.16;
    } else if (base <= 3751.05) {
      impostoApurado = (base * 0.15) - 394.16;
    } else if (base <= 4664.68) {
      impostoApurado = (base * 0.225) - 675.49;
    } else {
      impostoApurado = (base * 0.275) - 908.73;
    }
    if (impostoApurado < 0) impostoApurado = 0;
    impostoApurado = double.parse(impostoApurado.toStringAsFixed(2));
 
    // Redutor adicional para rendimento bruto entre R$5.000,01 e R$7.350,00.
    double redutor = 0;
    if (salarioBruto <= 7350.00) {
      redutor = 978.62 - (0.133145 * salarioBruto);
      if (redutor < 0) redutor = 0;
      redutor = double.parse(redutor.toStringAsFixed(2));
    }
 
    double valorFinal = impostoApurado - redutor;
    if (valorFinal < 0) valorFinal = 0;
    valorFinal = double.parse(valorFinal.toStringAsFixed(2));
 
    setState(() {
      _resultado = ResultadoIr(
        inssDescontado: inss,
        baseDeCalculo: double.parse(base.toStringAsFixed(2)),
        impostoAntesDoRedutor: impostoApurado,
        valorDoRedutor: redutor,
        valorFinal: valorFinal,
      );
    });
  }
 
  @override
  void dispose() {
    _salarioController.dispose();
    _dependentesController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Imposto de Renda')),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _dependentesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de dependentes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people_outline),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return 'Informe um número (0 se não houver)';
                  final numero = int.tryParse(valor);
                  if (numero == null || numero < 0) return 'Informe um número válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularIr,
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
 
  Widget _buildResultado(ResultadoIr r) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _linha('INSS descontado', _formatoMoeda.format(r.inssDescontado)),
            _linha('Base de cálculo do IR', _formatoMoeda.format(r.baseDeCalculo)),
            _linha('Imposto antes do redutor', _formatoMoeda.format(r.impostoAntesDoRedutor)),
            _linha('Redutor (Lei 15.270/2025)', '- ${_formatoMoeda.format(r.valorDoRedutor)}'),
            const Divider(),
            _linha('IR a recolher', _formatoMoeda.format(r.valorFinal), destaque: true),
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
              color: destaque ? Colors.blue : null,
              fontSize: destaque ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
 
