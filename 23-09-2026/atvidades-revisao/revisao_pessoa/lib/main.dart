import 'package:flutter/material.dart';

import 'models/pessoa.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polimorfismo: Pessoa/Estudante',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurpleAccent,
        useMaterial3: true,
      ),
      home: const TelaPessoas(),
    );
  }
}

class TelaPessoas extends StatelessWidget {
  const TelaPessoas({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Pessoa> pessoas = [
      //coloquei os nomes dos membros do meu pim :D
      Estudante('Bryan', 'Análise de sistemas'),
      Estudante('João', 'ADS'),
      Estudante('Murilo', 'Ciber'),
      Pessoa('Matheus'),
      Pessoa('Marco'),
      Pessoa('Leon')
      
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pessoa x Estudante')),
      body: ListView.builder(
        itemCount: pessoas.length,
        itemBuilder: (context, index) {
          final Pessoa pessoa = pessoas[index]; // referência do tipo pai

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: pessoa.cor,
                child: Icon(pessoa.icone, color: Colors.white),
              ),
              // pessoa.saudacao() executa a versão de Estudante quando
              // o objeto real é um Estudante — mesmo a variável sendo Pessoa.
              title: Text(pessoa.saudacao()),
              subtitle: Text(pessoa.runtimeType.toString()),
            ),
          );
        },
      ),
    );
  }
}
