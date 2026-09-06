class ResultadoCirculo {
  final double raio;
  final double area;

  ResultadoCirculo({
    required this.raio,
    required this.area,
  });
}

class ResultadoLosango {
  final double diagonalMaior;
  final double diagonalMenor;
  final double area;

  ResultadoLosango({
    required this.diagonalMaior,
    required this.diagonalMenor,
    required this.area,
  });
}

class ResultadoQuadrado {
  final double lado;
  final double area;

  ResultadoQuadrado({
    required this.lado,
    required this.area,
  });
}

class ResultadoRetangulo {
  final double base;
  final double altura;
  final double area;

  ResultadoRetangulo({
    required this.base,
    required this.altura,
    required this.area,
  });
}

class ResultadoTrapezio {
  final double baseMaior;
  final double baseMenor;
  final double altura;
  final double area;

  ResultadoTrapezio({
    required this.baseMaior,
    required this.baseMenor,
    required this.altura,
    required this.area,
  });
}

class ResultadoTriangulo {
  final double base;
  final double altura;
  final double area;

  ResultadoTriangulo({
    required this.base,
    required this.altura,
    required this.area,
  });
}
