// import 'package:flutter/material.dart';

// import '../../../models/preguntas.dart';

// class LeccionPage extends StatefulWidget {
//   final List<Pregunta> preguntas;

//   const LeccionPage({required this.preguntas});

//   @override
//   _LeccionPageState createState() => _LeccionPageState();
// }

// class _LeccionPageState extends State<LeccionPage> {
//   int currentPage = 0;
//   double progress = 0.0;

//   int selectedOptionIndex =
//       -1; // Inicializar como -1 para indicar que no se ha seleccionado ninguna opción

//   void checkAnswer(String selectedOption) {
//   final pregunta = widget.preguntas[currentPage];
//   if (pregunta.respuestaCorrecta == selectedOption) {
//     // Respuesta correcta
//     if (currentPage < widget.preguntas.length - 1) {
//       // Avanzar a la siguiente pregunta
//       setState(() {
//         //currentPage++;
//         progress = (currentPage + 1) / widget.preguntas.length;
//         selectedOptionIndex = pregunta.opciones.indexOf(selectedOption);
//       });
//     }
//   } else {
//     // Respuesta incorrecta
//     setState(() {
//       selectedOptionIndex = pregunta.opciones.indexOf(selectedOption);
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lección'),
//       ),
//       body: Column(
//         children: [
//           LinearProgressIndicator(
//             minHeight: 20.0,
//             value: progress,
//           ),
//           Text(
//             progress < 1.0
//                 ? '${(progress * 100).toInt()}% completado'
//                 : 'Completado',
//             style: TextStyle(fontSize: 16),
//           ),
//           Expanded(
//             child: PageView.builder(
//               itemCount: widget.preguntas.length,
//               controller: PageController(
//                 initialPage: currentPage,
//               ),
//               physics: NeverScrollableScrollPhysics(),
//               // onPageChanged: (int page) {
//               //   setState(() {
//               //     currentPage = page;
//               //     progress = (currentPage + 1) / widget.preguntas.length;
//               //     selectedOptionIndex = -1; // Reiniciar el estado de selección
//               //   });
//               // },
//               itemBuilder: (context, index) {
//                 final pregunta = widget.preguntas[currentPage];

//                 return Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Pregunta ${currentPage + 1}:',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         pregunta.enunciado,
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       Image.network(
//                         pregunta.imagen!,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Image.asset(
//                             'assets/images/default_image.png',
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Opciones de respuesta:',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       SizedBox(height: 10),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: pregunta.opciones.length,
//                         itemBuilder: (context, optionIndex) {
//                           final opcion = pregunta.opciones[optionIndex];
//                           return Padding(
//                             padding: EdgeInsets.symmetric(vertical: 4),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 checkAnswer(opcion);
//                               },
//                               style: ButtonStyle(
//                                 backgroundColor: selectedOptionIndex ==
//                                         optionIndex
//                                     ? pregunta.respuestaCorrecta == opcion
//                                         ? MaterialStateProperty.all<Color>(Colors
//                                             .green) // Cambiar el color a verde para la respuesta correcta
//                                         : MaterialStateProperty.all<Color>(Colors
//                                             .red) // Cambiar el color a rojo para la respuesta incorrecta
//                                     : null,
//                               ),
//                               child: Text(
//                                 opcion,
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       SizedBox(height: 10),
//                       selectedOptionIndex != -1
//                           ? Text(
//                               pregunta.respuestaCorrecta ==
//                                       pregunta.opciones[selectedOptionIndex]
//                                   ? 'Respuesta correcta'
//                                   : 'Respuesta incorrecta',
//                               style: TextStyle(
//                                 color: pregunta.respuestaCorrecta ==
//                                         pregunta.opciones[selectedOptionIndex]
//                                     ? Colors.green
//                                     : Colors.red,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                           : Container(),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (currentPage < widget.preguntas.length - 1) {
//                 // Avanzar a la siguiente pregunta
//                 setState(() {
//                   currentPage++;
//                   progress = (currentPage + 1) / widget.preguntas.length;
//                   selectedOptionIndex = -1; // Reiniciar el estado de selección
//                 });
//               } else {
//                 // Finalizar la lección
//                 Navigator.pop(context);
//               }
//             },
//             child: Text(
//               currentPage < widget.preguntas.length - 1
//                   ? 'Siguiente'
//                   : 'Finalizar',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../../models/preguntas.dart';

class LeccionPage extends StatefulWidget {
  final List<Pregunta> preguntas;

  const LeccionPage({required this.preguntas});

  @override
  _LeccionPageState createState() => _LeccionPageState();
}

class _LeccionPageState extends State<LeccionPage> {
  int currentPage = 0;
  double progress = 0.0;

  int selectedOptionIndex =
      -1; // Inicializar como -1 para indicar que no se ha seleccionado ninguna opción

  void checkAnswer(String selectedOption) {
    final pregunta = widget.preguntas[currentPage];
    if (pregunta.respuestaCorrecta == selectedOption) {
      // Respuesta correcta
      if (currentPage <= widget.preguntas.length - 1) {
        // Avanzar a la siguiente pregunta
        setState(() {
          //currentPage++;
          progress = (currentPage + 1) / widget.preguntas.length;
          selectedOptionIndex = pregunta.opciones.indexOf(selectedOption);
        });
      }
    } else {
      // Respuesta incorrecta
      setState(() {
        selectedOptionIndex = pregunta.opciones.indexOf(selectedOption);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lección'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 20.0,
            value: progress,
          ),
          Text(
            progress < 1.0
                ? '${(progress * 100).toInt()}% completado'
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
              // onPageChanged: (int page) {
              //   setState(() {
              //     currentPage = page;
              //     progress = (currentPage + 1) / widget.preguntas.length;
              //     selectedOptionIndex = -1; // Reiniciar el estado de selección
              //   });
              // },
              itemBuilder: (context, index) {
                final pregunta = widget.preguntas[currentPage];

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
                      Text(
                        'Opciones de respuesta:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: pregunta.opciones.length,
                        itemBuilder: (context, optionIndex) {
                          final opcion = pregunta.opciones[optionIndex];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                checkAnswer(opcion);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    selectedOptionIndex == optionIndex
                                        ? MaterialStateProperty.all<Color>(
                                            Colors.black54)
                                        : null,
                              ),
                              child: Text(
                                opcion,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (currentPage < widget.preguntas.length - 1) {
                // Avanzar a la siguiente pregunta
                setState(() {
                  currentPage++;
                  progress = (currentPage + 1) / widget.preguntas.length;
                  selectedOptionIndex = -1; // Reiniciar el estado de selección
                });
              } else {
                // Finalizar la lección
                Navigator.pop(context);
              }
            },
            child: Text(
              currentPage < widget.preguntas.length - 1
                  ? 'CONFIRMAR'
                  : 'FINALIZAR',
              style: TextStyle(fontSize: 20), // Tamaño de texto personalizado
            ),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                  Size(double.infinity, 50)), // Ancho y alto personalizados
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue[900]!), // Fondo azul
            ),
          ),
        ],
      ),
    );
  }
}
