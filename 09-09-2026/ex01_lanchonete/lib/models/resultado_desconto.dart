// ============================================================================
// MODELO — guarda apenas os dados de entrada/saída deste cálculo.
// ============================================================================
class ResultadoDesconto {
  final double valorCompra;
  final double percentual;
  final double valorDesconto;
  final double valorFinal;

  ResultadoDesconto({
    required this.valorCompra,
    required this.percentual,
    required this.valorDesconto,
    required this.valorFinal,
  });
}
