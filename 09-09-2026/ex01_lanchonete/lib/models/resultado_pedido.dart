// ============================================================================
// MODELO — guarda apenas os dados de entrada/saída deste cálculo.
// ============================================================================
class ResultadoPedido {
  final int quantidade;
  final double precoUnitario;
  final double taxaEntrega;
  final double subtotal;
  final double total;
  ResultadoPedido({
    required this.quantidade,
    required this.precoUnitario,
    required this.taxaEntrega,
    required this.subtotal,
    required this.total,
  });
}
