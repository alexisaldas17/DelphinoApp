import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(HangmanGame());
}

class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  List<String> words = [
    'ABEJA',
    'ESCOBA',
    'MALETA',
    'CUADERNO',
    'PROFESORA',
    'ARAÑA',
  ];

  String selectedWord = '';
  List<String> displayedWord = [];
  List<String> guessedLetters = [];
  int remainingAttempts = 6;
  int incorrectGuesses = 0;

  @override
  void initState() {
    super.initState();
    selectRandomWord();
  }

  void selectRandomWord() {
    Random random = Random();
    selectedWord = words[random.nextInt(words.length)];
    displayedWord = List<String>.filled(selectedWord.length, '_');
    guessedLetters.clear();
    remainingAttempts = 6;
    incorrectGuesses = 0;
  }

  void guessLetter(String letter) {
    setState(() {
      if (!guessedLetters.contains(letter)) {
        guessedLetters.add(letter);
        if (selectedWord.contains(letter)) {
          for (int i = 0; i < selectedWord.length; i++) {
            if (selectedWord[i] == letter) {
              displayedWord[i] = letter;
            }
          }
          if (!displayedWord.contains('_')) {
            // Player has won the game
            showGameOverDialog('Felicitaciones! Tu Ganaste!');
          }
        } else {
          incorrectGuesses++;
          if (incorrectGuesses == remainingAttempts) {
            // Player has lost the game
            showGameOverDialog('Oops! Perdiste. Intenta nuevamente!');
          }
        }
      }
    });
  }

  void showGameOverDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hey!'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Jugar de nuevo'),
              onPressed: () {
                selectRandomWord();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('AHORCADO'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                'Adivina la palabra :',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                displayedWord.join(' '),
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: 200,
                child: Image.asset(
                  'assets/images/hangman_$incorrectGuesses.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Intentos Restantes: ${remainingAttempts - incorrectGuesses}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 5, // Cambiar a 5 columnas
                  mainAxisSpacing: 5, // Espacio vertical entre los botones
                  crossAxisSpacing: 5, // Espacio horizontal entre los botones
                  childAspectRatio: 1, // Relación de aspecto cuadrada para los botones
                  children: List.generate(26, (index) {
                    final letter = String.fromCharCode(index + 65);
                    return GestureDetector(
                      onTap: () => guessLetter(letter),
                      child: Container(
                        decoration: BoxDecoration(
                          color: guessedLetters.contains(letter)
                              ? Colors.grey
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/abecedario/${letter.toLowerCase()}.PNG',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
