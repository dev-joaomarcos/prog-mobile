class Conta {
  
  final int _numero;
  double _saldo;

  Conta(this._numero, this._saldo);

  // Getter público — única forma de "ler" o saldo de fora da classe.
  double getSaldo() => _saldo;

  // Getter público também para o número da conta, exposto de propósito
  // (nem tudo precisa ficar oculto — só o que exige controle de acesso).
  int get numero => _numero;

  // Regra de negócio: só a própria classe pode alterar _saldo.
  void depositar(double valor) {
    if (valor <= 0) {
      throw ArgumentError('O valor do depósito deve ser positivo.');
    }
    _saldo += valor;
  }

  void sacar(double valor) {
    if (valor <= 0) {
      throw ArgumentError('O valor do saque deve ser positivo.');
    }
    if (valor > _saldo) {
      throw StateError('Saldo insuficiente.');
    }
    _saldo -= valor;
  }
}
