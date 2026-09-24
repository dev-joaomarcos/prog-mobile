// ignore: file_names
import 'package:flutter/material.dart';

class Pessoa {
  final String nome;
  Pessoa(this.nome);
  String saudacao() => 'Olá, meu nome é $nome.';
  
  IconData get icone => Icons.person;
  Color get cor => Colors.orangeAccent;
}

class Estudante extends Pessoa {
  final String curso;
  Estudante(super.nome, this.curso);

  @override
  String saudacao() => 'Oi, meu nome é $nome e sou estudante de $curso.';

  @override
  IconData get icone => Icons.school;

  @override
  Color get cor => Colors.deepOrangeAccent;
}
