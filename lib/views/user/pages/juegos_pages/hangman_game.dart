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
  String guessedWord = '';
  Set<String> selectedLetters = {};

  List<String> words = [
    'ABEJA',
    'ESCOBA',
    'MALETA',
    'CUADERNO',
    'PROFESORA',
    'GATO',
    'BORRADOR',
    'AMOR',
    'LIBRO',
    'COMPUTADORA',
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
    guessedWord = '';
    remainingAttempts = 6;
    incorrectGuesses = 0;
  }

  void restartGame() {
    setState(() {
      selectRandomWord();
      resetSelectedLetters();
    });
  }

  void resetSelectedLetters() {
    selectedLetters = {}; // Restablecer a un conjunto vacío
  }

  void showGameOverDialog(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¡Hey!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: ElevatedButton(
                      onPressed: () {
                        restartGame();
                        Navigator.of(context).pop();
                      },
                      child: Text('Jugar de nuevo'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showHintDialog(String hint) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pista'),
          content: Text(hint),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void guessLetter(String letter) {
    setState(() {
      if (!guessedLetters.contains(letter)) {
        selectedLetters.add(letter);
        guessedLetters.add(letter);
        if (selectedWord.contains(letter)) {
          for (int i = 0; i < selectedWord.length; i++) {
            if (selectedWord[i] == letter) {
              displayedWord[i] = letter;
            }
          }
          if (!displayedWord.contains('_')) {
            guessedWord = selectedWord;
            // El jugador ha ganado el juego
            showGameOverDialog(
                '¡Felicitaciones! ¡Ganaste! Palabra: $guessedWord');

            restartGame();
          }
        } else {
          incorrectGuesses++;
          if (incorrectGuesses == remainingAttempts) {
            // El jugador ha perdido el juego
            showGameOverDialog('¡Oops! ¡Perdiste! ¡Inténtalo de nuevo!');
            restartGame();
          }
        }
      }
    });
  }

  void requestHint() {
    // Obtener una pista al azar de la palabra seleccionada
    Random random = Random();
    int randomIndex = random.nextInt(selectedWord.length);
    String hint = selectedWord[randomIndex];
    showHintDialog('Una letra en la palabra es: $hint');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mostrar diálogo de confirmación al navegar hacia atrás
        bool confirmExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('¿Estás seguro?'),
            content: Text('¿Deseas salir del juego?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // No confirmar la salida
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirmar la salida
                },
                child: Text('Salir'),
              ),
            ],
          ),
        );

        return confirmExit ?? false;
      },
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('AHORCADO'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Adivina la palabra:',
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
                    'assets/images/hangman_${min(incorrectGuesses, 6)}.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Imagen no encontrada');
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Intentos Restantes: ${remainingAttempts - incorrectGuesses}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    requestHint();
                  },
                  child: Text('Pista'),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                    children: List.generate(26, (index) {
                      final letter = String.fromCharCode(index + 65);
                      final isSelected = selectedLetters.contains(letter);
                      final image = Image.asset(
                        'assets/abecedario/${letter.toLowerCase()}.PNG',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text('Imagen no encontrada');
                        },
                      );
                      if (isSelected) {
                        return GestureDetector(
                          onTap: () => guessLetter(letter),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                            child: image,
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () => guessLetter(letter),
                          child: image,
                        );
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
