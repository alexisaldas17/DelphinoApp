import 'dart:math';
import 'package:flutter/material.dart';

class SopaDeSenasPage extends StatefulWidget {
  @override
  State<SopaDeSenasPage> createState() => _SopaDeSenasPageState();
}

class _SopaDeSenasPageState extends State<SopaDeSenasPage> {
 final List<String> palabrasPredefinidas = [
    'FLUTTER',
    'DART',
    'WIDGET',
    'ANDROID',
    'IOS',
    'MOBILE',
  ];

  final int dimension = 10;
  List<List<String>> matriz = [];

  @override
  void initState() {
    super.initState();
    generarMatriz();
  }

void generarMatriz() {
  matriz = List.generate(dimension, (i) => List.generate(dimension, (j) => '', growable: false));

  final Random random = Random();

  for (int i = 0; i < dimension; i++) {
    for (int j = 0; j < dimension; j++) {
      if (matriz[i][j] == '') {
        matriz[i][j] = generarLetraAleatoria(random);
      }
    }
  }

  palabrasPredefinidas.shuffle(); // Mezcla las palabras predefinidas para insertarlas en un orden aleatorio

  for (String palabra in palabrasPredefinidas) {
    bool insertada = false;
    int intentos = 0;
    final int maxIntentos = 100; // Establece un límite máximo de intentos

    while (!insertada && intentos < maxIntentos) { // Agrega la condición intentos < maxIntentos al bucle
      int fila = random.nextInt(dimension);
      int columna = random.nextInt(dimension);
      bool horizontal = random.nextBool();

      if (verificarDisponibilidad(palabra, fila, columna, horizontal)) {
        insertarPalabra(palabra, fila, columna, horizontal);
        insertada = true;
      }

      intentos++;
    }
  }
}


String generarLetraAleatoria(Random random) {
  final int codigoBase = 'A'.codeUnitAt(0);
  final int numLetras = 26;

  int codigoLetra = codigoBase + random.nextInt(numLetras);
  return String.fromCharCode(codigoLetra);
}

  bool verificarDisponibilidad(String palabra, int fila, int columna, bool horizontal) {
    if (horizontal && columna + palabra.length <= dimension) {
      for (int i = 0; i < palabra.length; i++) {
        if (matriz[fila][columna + i] != '') {
          return false;
        }
      }
      return true;
    } else if (!horizontal && fila + palabra.length <= dimension) {
      for (int i = 0; i < palabra.length; i++) {
        if (matriz[fila + i][columna] != '') {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  void insertarPalabra(String palabra, int fila, int columna, bool horizontal) {
    if (horizontal) {
      for (int i = 0; i < palabra.length; i++) {
        matriz[fila][columna + i] = palabra[i];
      }
    } else {
      for (int i = 0; i < palabra.length; i++) {
        matriz[fila + i][columna] = palabra[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sopa de Letras'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: dimension,
              ),
              itemBuilder: (BuildContext context, int index) {
                int fila = index ~/ dimension;
                int columna = index % dimension;

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Center(
                    child: Text(matriz[fila][columna]),
                  ),
                );
              },
              itemCount: dimension * dimension,
            ),
          ],
        ),
      ),
    );
  }
}