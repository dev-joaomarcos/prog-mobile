import 'package:flutter/material.dart';

import 'models/conta.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encapsulamento: Conta Bancária',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurpleAccent,
        useMaterial3: true,
      ),
      home: const TelaConta(),
    );
  }
}

class TelaConta extends StatefulWidget {
  const TelaConta({super.key});

  @override
  State<TelaConta> createState() => _TelaContaState();
}

class _TelaContaState extends State<TelaConta> {
  // O objeto Conta vive aqui, dentro do State. A tela guarda apenas
  // a REFERÊNCIA ao objeto — o saldo em si está protegido dentro dele.
  final Conta _conta = Conta(67420, 1000);
  final TextEditingController _valorController = TextEditingController();
  String? _mensagemErro;

  void _depositar() {
    final valor = double.tryParse(_valorController.text.replaceAll(',', '.'));
    if (valor == null) {
      setState(() => _mensagemErro = 'Informe um valor numérico válido.');
      return;
    }
    setState(() {
      try {
        _conta.depositar(valor); // única forma de alterar o saldo
        _mensagemErro = null;
        _valorController.clear();
      } catch (e) {
        _mensagemErro = e.toString();
      }
    });
  }

  void _sacar() {
    final valor = double.tryParse(_valorController.text.replaceAll(',', '.'));
    if (valor == null) {
      setState(() => _mensagemErro = 'Informe um valor numérico válido.');
      return;
    }
    setState(() {
      try {
        _conta.sacar(valor); // única forma de alterar o saldo
        _mensagemErro = null;
        _valorController.clear();
      } catch (e) {
        _mensagemErro = e.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conta Bancária')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Conta nº ${_conta.numero}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    // Leitura sempre via getSaldo() — nunca via _saldo direto.
                    Text(
                      'Saldo: R\$ ${_conta.getSaldo().toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _valorController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
            ),
            if (_mensagemErro != null) ...[
              const SizedBox(height: 8),
              Text(_mensagemErro!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _depositar,
                    child: const Text('Depositar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _sacar,
                    child: const Text('Sacar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
