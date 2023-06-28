import 'dart:math';

import 'package:flutter/material.dart';

class SopaDeSenasPage extends StatefulWidget {
  @override
  State<SopaDeSenasPage> createState() => _SopaDeSenasPageState();
}

class _SopaDeSenasPageState extends State<SopaDeSenasPage> {
  List<String> words = ['FLUTTER', 'DART', 'WIDGET', 'ANDROID', 'IOS'];
  List<List<String>> grid = [];
  List<List<bool>> selectedCells = [];
  String selectedWord = '';
  bool isWordFound = false;

  @override
  void initState() {
    super.initState();
    generateGrid();
  }

 void generateGrid() {
  grid = [];
  selectedCells = [];

  final random = Random();

  // Obtener una palabra aleatoria de la lista de palabras
  String randomWord = words[random.nextInt(words.length)];

  // Obtener la longitud de la palabra aleatoria
  int wordLength = randomWord.length;

  // Generar una cuadrícula de 10x10 con letras aleatorias
  for (int i = 0; i < 10; i++) {
    List<String> row = [];
    List<bool> selectedRow = [];
    for (int j = 0; j < 10; j++) {
      // Generar una letra aleatoria o rellenar con espacios en blanco
      String letter = (j < wordLength) ? randomWord[j] : String.fromCharCode(random.nextInt(26) + 65);
      row.add(letter);
      selectedRow.add(false);
    }
    grid.add(row);
    selectedCells.add(selectedRow);
  }
}


  void selectCell(int row, int col) {
    setState(() {
      if (selectedWord.isEmpty) {
        selectedWord += grid[row][col];
        selectedCells[row][col] = true;
      } else {
        int lastSelectedRow = -1;
        int lastSelectedCol = -1;

        // Encontrar la última celda seleccionada
        for (int i = 0; i < selectedCells.length; i++) {
          for (int j = 0; j < selectedCells[i].length; j++) {
            if (selectedCells[i][j]) {
              lastSelectedRow = i;
              lastSelectedCol = j;
            }
          }
        }

        // Verificar si la celda actual es adyacente a la última celda seleccionada
        if ((row == lastSelectedRow && (col - lastSelectedCol).abs() == 1) ||
            (col == lastSelectedCol && (row - lastSelectedRow).abs() == 1) ||
            ((row - lastSelectedRow).abs() == 1 && (col - lastSelectedCol).abs() == 1)) {
          selectedWord += grid[row][col];
          selectedCells[row][col] = true;
        }
      }
    });
  }

  void checkWord() {
    setState(() {
      isWordFound = words.contains(selectedWord);
      selectedWord = '';
      resetSelectedCells();
    });
  }

  void resetSelectedCells() {
    for (int i = 0; i < selectedCells.length; i++) {
      for (int j = 0; j < selectedCells[i].length; j++) {
        selectedCells[i][j] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sopa de Letras'),
      ),
      body: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              int row = index ~/ 10;
              int col = index % 10;
              String letter = grid[row][col];
              bool isSelected = selectedCells[row][col];
              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    checkWord();
                  } else {
                    selectCell(row, col);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    border: Border.all(),
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16.0),
          Text(
            'Palabra seleccionada: $selectedWord',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () => checkWord(),
            child: Text('Verificar Palabra'),
          ),
          SizedBox(height: 16.0),
          Text(
            'Palabra encontrada: ${isWordFound ? 'Sí' : 'No'}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}