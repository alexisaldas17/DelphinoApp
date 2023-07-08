import 'dart:async';

import 'package:delphino_app/models/lecciones.dart';
import 'package:delphino_app/providers/aprender.provider.dart';
import 'package:delphino_app/providers/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../models/niveles.dart';
import '../../../../models/preguntas.dart';
import '../../../../models/subniveles.dart';

class LeccionPage extends StatefulWidget {
  final Subnivel subnivel;
  final List<Pregunta> preguntas;
  final Leccion leccion;

  const LeccionPage(
      {required this.preguntas, required this.leccion, required this.subnivel});

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

  Nivel? obtenerNivelDelSubnivel(Subnivel subnivel, List<Nivel>? niveles) {
    if (niveles != null) {
      return niveles.firstWhere(
        (nivel) => nivel.subniveles
            .any((nivelSubnivel) => nivelSubnivel.nombre == subnivel.nombre),
        orElse: () => Nivel.empty(),
      );
    }
    return null;
  }

  void checkAnswer(int selectedOption) {
    final pregunta = widget.preguntas[currentPage];
    bool isAnswerCorrect = pregunta.respuestaCorrecta == selectedOption;

    if (mounted) {
      setState(() {
        selectedOptionIndex = selectedOption;
        questionResults.add(isAnswerCorrect);
      });
    }

    if (currentPage < widget.preguntas.length - 1) {
      if (isAnswerCorrect) {
        showCorrectToast();
      } else {
        showIncorrectToast();
      }

      Timer(Duration(seconds: 3), () {
        if (mounted) {
          // Avanzar a la siguiente pregunta
          setState(() {
            currentPage++;
            progress = (currentPage + 1) / widget.preguntas.length;
            selectedOptionIndex = -1; // Reiniciar el estado de selección
          });
        }
      });
    } else {
      if (isAnswerCorrect) {
        showCorrectToast();
      } else {
        showIncorrectToast();
      }

      Timer(Duration(seconds: 3), () {
        if (mounted) {
          // Finalizar la lección después de mostrar el mensaje de respuesta
          Navigator.pop(context);

          if (questionResults.every((result) => result == true)) {
            // Todas las respuestas son correctas
            final UserProvider userProvider =
                Provider.of<UserProvider>(context, listen: false);
            final AprenderProvider aprenderProvider =
                Provider.of<AprenderProvider>(context, listen: false);
            userProvider.completarLeccion(widget.leccion);

            Nivel? nivel = obtenerNivelDelSubnivel(
                widget.subnivel, aprenderProvider.niveles);

            //Verificar si ya se completaron todas las lecciones
            bool compleatado = userProvider.todasLasLeccionesDelSubnivelCompletadas(
                widget.subnivel, nivel);
            if(compleatado)
            aprenderProvider.obtenerNivelesDesdeFirebase().then((result) {
              showCompletedToast(nivel!);
            });

            // Ejemplo de llamada al método
            showCompletedDialog(context);
          } else {
            // Al menos una respuesta es incorrecta
            showIncorrectAnswers(context);
          }
        }
      });
    }
  }

  void showCompletedToast(Nivel nivel) {
    late Subnivel siguienteSubnivel;
    if (nivel != null) {
      int subnivelIndex = nivel.subniveles.indexOf(widget.subnivel);
        subnivelIndex = subnivelIndex == -1 ? 0 : subnivelIndex;
        int siguienteSubnivelIndex = subnivelIndex + 1;
      if (siguienteSubnivelIndex < nivel.subniveles.length) {
        siguienteSubnivel = nivel.subniveles[siguienteSubnivelIndex];
      }
    }
    Fluttertoast.showToast(
      msg: '¡Felicidades! Subnivel ${siguienteSubnivel.nombre} habilitado.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 1,
      webBgColor: "#009688",
      webPosition: "center",
      webShowClose: true,
    );
  }

  void showSubnivelCompletadoToast() {
    Fluttertoast.showToast(
      msg: '¡Felicidades! 100% Completado',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 1,
      webBgColor: "#009688",
      webPosition: "center",
      webShowClose: true,
    );
  }

  void showCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.only(top: 66.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '¡Felicidades!',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '100% Completado',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      child: Text('Cerrar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -10.0,
                child: Image.asset(
                  'assets/balloons.png', // Reemplaza con la ruta de la imagen de los globos
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showIncorrectAnswers(BuildContext context) {
    List<int> incorrectIndexes = [];
    List<int> correctIndexes = [];

    for (int i = 0; i < questionResults.length; i++) {
      if (!questionResults[i]) {
        incorrectIndexes.add(i + 1);
      } else {
        correctIndexes.add(i + 1);
      }
    }

    setState(() {
      incorrectQuestions = incorrectIndexes;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Respuestas incorrectas y correctas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preguntas incorrectas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: incorrectIndexes
                    .map((index) => Text('Pregunta: $index'))
                    .toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                'Preguntas correctas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              correctIndexes.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: correctIndexes
                          .map((index) => Text('Pregunta: $index'))
                          .toList(),
                    )
                  : Text(
                      'No acertaste nunguna respuesta',
                    ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showIncorrectToast() {
    Fluttertoast.showToast(
      msg: 'Respuesta incorrecta',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 1,
      webBgColor: "#009688",
      webPosition: "center",
      webShowClose: true,
    );
  }

  void showCorrectToast() {
    Fluttertoast.showToast(
      msg: 'Respuesta Correcta',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 1,
      webBgColor: "#009688",
      webPosition: "center",
      webShowClose: true,
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
    return SingleChildScrollView(
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2, // Número de columnas deseadas
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
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
      ),
    );
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
            content: Text('¿Deseas salir de la Lección?'),
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
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 45.0), // Espacio en la parte superior
          child: Column(
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
              TextButton.icon(
                onPressed: isConfirmButtonEnabled()
                    ? () {
                        checkAnswer(selectedOption);
                      }
                    : null,
                icon: Icon(Icons.check),
                label: Text(
                  currentPage < widget.preguntas.length - 1
                      ? 'CONFIRMAR'
                      : 'FINALIZAR',
                  style: TextStyle(fontSize: 20),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey as Color; // Explicit cast to Color
                      }
                      return Colors.white as Color; // Explicit cast to Color
                    },
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.blueGrey
                            as Color; // Explicit cast to Color
                      }
                      return Colors.blue[900]
                          as Color; // Explicit cast to Color
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
