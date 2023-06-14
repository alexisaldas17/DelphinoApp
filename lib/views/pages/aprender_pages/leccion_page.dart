import 'dart:async';

import 'package:delphino_app/models/lecciones.dart';
import 'package:delphino_app/providers/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../models/preguntas.dart';

class LeccionPage extends StatefulWidget {
  final List<Pregunta> preguntas;
  final Leccion leccion;

  const LeccionPage({required this.preguntas, required this.leccion});

  @override
  _LeccionPageState createState() => _LeccionPageState();
}

class _LeccionPageState extends State<LeccionPage> {
  int currentPage = 0;
  double progress = 0.0;
  List<bool> questionResults = [];
  List<int> incorrectQuestions = [];
  bool isAnswerCorrect = false;
  int selectedOption = -1;
  int selectedOptionIndex = -1;
  bool isConfirmButtonEnabled() {
    return selectedOptionIndex != -1;
  }

  void checkAnswer(int selectedOption) {
    final pregunta = widget.preguntas[currentPage];
    bool isAnswerCorrect = pregunta.respuestaCorrecta == selectedOption;
    setState(() {
      selectedOptionIndex = selectedOption;
      questionResults.add(isAnswerCorrect);
    });

    if (currentPage < widget.preguntas.length - 1) {
      if (isAnswerCorrect) {
        showCorrectToast();
      } else {
        showIncorrectToast();
      }

      Timer(Duration(seconds: 3), () {
        // Avanzar a la siguiente pregunta
        setState(() {
          currentPage++;
          progress = (currentPage + 1) / widget.preguntas.length;
          selectedOptionIndex = -1; // Reiniciar el estado de selección
        });
      });
    } else {
      if (isAnswerCorrect) {
        showCorrectToast();
      } else {
        showIncorrectToast();
      }

      Timer(Duration(seconds: 3), () {
        // Finalizar la lección después de mostrar el mensaje de respuesta
        Navigator.pop(context);

        if (questionResults.every((result) => result == true)) {
          // Todas las respuestas son correctas
           final UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
          userProvider.completarLeccion(widget.leccion);
          showCompletedToast();
        } else {
          // Al menos una respuesta es incorrecta
          showIncorrectAnswers();
        }
      });
    }
  }

  void showCompletedToast() {
    Fluttertoast.showToast(
      msg: '100% Completado',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  void showIncorrectAnswers() {
    List<int> incorrectIndexes = [];
    for (int i = 0; i < questionResults.length; i++) {
      if (!questionResults[i]) {
        incorrectIndexes.add(i + 1);
      }
    }

    setState(() {
      incorrectQuestions = incorrectIndexes;
    });

    Fluttertoast.showToast(
      msg: 'Respuestas incorrectas: ${incorrectIndexes.join(", ")}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  void showIncorrectToast() {
    Fluttertoast.showToast(
      msg: 'Respuesta incorrecta',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  void showCorrectToast() {
    Fluttertoast.showToast(
      msg: 'Respuesta Correcta',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  Widget buildOptions(List<String> opciones) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: opciones.length,
      itemBuilder: (context, optionIndex) {
        final opcion = opciones[optionIndex];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedOptionIndex = optionIndex;
                selectedOption = selectedOptionIndex;
              });
            },
            style: ButtonStyle(
              backgroundColor: selectedOptionIndex == optionIndex
                  ? MaterialStateProperty.all<Color>(Colors.black54)
                  : null,
            ),
            child: Text(
              opcion,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget buildImageOptions(List<String> opciones) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: opciones.asMap().entries.map((entry) {
        final optionIndex = entry.key;
        final opcion = entry.value;
        return ElevatedButton(
          onPressed: () {
            setState(() {
              selectedOptionIndex = optionIndex;
              selectedOption = selectedOptionIndex;
            });
          },
          style: ButtonStyle(
            backgroundColor: selectedOptionIndex == optionIndex
                ? MaterialStateProperty.all<Color>(Colors.black54)
                : null,
          ),
          child: Image.network(
            opcion,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/default_image.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              );
            },
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 20.0,
            value: progress,
          ),
          Text(
            progress <= 1.0
                ? '${(progress * 100).toInt()}% Completado'
                : 'Completado',
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: widget.preguntas.length,
              controller: PageController(
                initialPage: currentPage,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Pregunta pregunta = widget.preguntas[
                    currentPage]; // Inicializar pregunta con la pregunta actual

                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pregunta ${currentPage + 1}:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        pregunta.enunciado,
                        style: TextStyle(fontSize: 18),
                      ),
                      if (pregunta.tipo == 'opcion')
                        Image.network(
                          pregunta.imagen!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/default_image.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      SizedBox(height: 10),
                      if (pregunta.tipo == 'opcion')
                        buildOptions(pregunta.opciones),
                      if (pregunta.tipo == 'imagen')
                        buildImageOptions(pregunta.opciones),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: isConfirmButtonEnabled()
                ? () {
                    checkAnswer(selectedOption);
                  }
                : null,
            child: Text(
              currentPage < widget.preguntas.length - 1
                  ? 'CONFIRMAR'
                  : 'FINALIZAR',
              style: TextStyle(fontSize: 20),
            ),
            style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue[900]!),
            ),
          ),
        ],
      ),
    );
  }
}
