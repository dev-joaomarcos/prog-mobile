// ============================================================================
// MODELO — guarda apenas os dados de entrada/saída deste cálculo.
// ============================================================================
class ResultadoTroco {
  final double valorCompra;
  final double valorPago;
  final double troco;
  final bool valorInsuficiente;
  ResultadoTroco({
    required this.valorCompra,
    required this.valorPago,
    required this.troco,
    required this.valorInsuficiente,
  });
}
