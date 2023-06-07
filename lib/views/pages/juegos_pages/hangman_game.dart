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
    'FLUTTER',
    'DEVELOPMENT',
    'GAME',
    'HANGMAN',
    'LANGUAGE',
    'SIGN',
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
            showGameOverDialog('Congratulations! You won!');
          }
        } else {
          incorrectGuesses++;
          if (incorrectGuesses == remainingAttempts) {
            // Player has lost the game
            showGameOverDialog('Oops! You lost. Try again!');
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
          title: Text('Game Over'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Play Again'),
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
          title: Text('Hangman Game'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                'Guess the word:',
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
                'Remaining Attempts: ${remainingAttempts - incorrectGuesses}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: List.generate(26, (index) {
                  final letter = String.fromCharCode(index + 65);
                  return GestureDetector(
                    onTap: () => guessLetter(letter),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: guessedLetters.contains(letter)
                            ? Colors.grey
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
