import 'dart:async';

import 'package:flutter/material.dart';

class MemoryCardsPage extends StatefulWidget {
  @override
  _MemoryCardsPageState createState() => _MemoryCardsPageState();
}

class _MemoryCardsPageState extends State<MemoryCardsPage> {
  bool _showingHint = false;

  List<String> _cardImages = [
    'assets/abecedario/a.PNG',
    'assets/abecedario/b.PNG',
    'assets/abecedario/c.PNG',
    'assets/abecedario/d.PNG',
    'assets/abecedario/e.PNG',
    'assets/abecedario/f.PNG',
    'assets/abecedario/g.PNG',
    'assets/abecedario/h.PNG',
    'assets/abecedario/i.PNG',
    'assets/abecedario/j.PNG',
    'assets/abecedario/k.PNG',
    'assets/abecedario/l.PNG',
    'assets/abecedario/m.PNG',
    'assets/abecedario/n.PNG',
    'assets/abecedario/o.PNG',
    'assets/abecedario/p.PNG',
    'assets/abecedario/q.PNG',
    'assets/abecedario/r.PNG',
    'assets/abecedario/s.PNG',
    'assets/abecedario/t.PNG',
    'assets/abecedario/u.PNG',
    'assets/abecedario/v.PNG',
    'assets/abecedario/w.PNG',
    'assets/abecedario/x.PNG',
    'assets/abecedario/y.PNG',
    'assets/abecedario/z.PNG',
  ];

  List<String> _cards = [];
  List<bool> _cardFlips = [];
  bool _canFlip = true;
  int _previousCardIndex = -1;
  int _pairsFound = 0;
  int _difficultyLevel = 0;
  bool _showDifficultyDialog = true;

  List<int> _difficultyLevels = [
    8,
    12,
    16
  ]; // Número de pares de tarjetas para cada nivel de dificultad
  @override
  void initState() {
    super.initState();
    _initializeCards();
    _showDifficultyDialog = true; // Mostrar el cuadro de diálogo al inicio

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _showTourDialog(); // Llamar al método para mostrar el cuadro de diálogo de tour
    });
  }

  void _showDifficultySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona la dificultad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _difficultyLevel = 0; // Modo Fácil
                    _showDifficultyDialog =
                        false; // Ocultar el cuadro de diálogo
                    _initializeCards(); // Inicializar las tarjetas según la dificultad seleccionada
                  });
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                },
                child: Text('Fácil'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green), // Color de fondo del botón
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                      color: Colors.white)), // Color del texto del botón
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 50)), // Tamaño mínimo del botón
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _difficultyLevel = 1; // Modo Intermedio
                    _showDifficultyDialog =
                        false; // Ocultar el cuadro de diálogo
                    _initializeCards(); // Inicializar las tarjetas según la dificultad seleccionada
                  });
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                },
                child: Text('Intermedio'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.orange), // Color de fondo del botón
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                      color: Colors.white)), // Color del texto del botón
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 50)), // Tamaño mínimo del botón
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _difficultyLevel = 2; // Modo Avanzado
                    _showDifficultyDialog =
                        false; // Ocultar el cuadro de diálogo
                    _initializeCards(); // Inicializar las tarjetas según la dificultad seleccionada
                  });
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                },
                child: Text('Avanzado'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.red), // Color de fondo del botón
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                      color: Colors.white)), // Color del texto del botón
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 50)), // Tamaño mínimo del botón
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _initializeCards() {
    _cards.clear();
    _cardFlips.clear();
    int numberOfPairs = _difficultyLevels[_difficultyLevel];

    // Duplicar las imágenes de las tarjetas para crear los pares
    for (int i = 0; i < numberOfPairs; i++) {
      _cards.add(_cardImages[i]);
      _cards.add(_cardImages[i]);
      _cardFlips.add(false);
      _cardFlips.add(false);
    }

    // Barajar las tarjetas
    _cards.shuffle();
  }

  void _flipCard(int index) {
    if (!_canFlip || _cardFlips[index]) {
      return;
    }

    setState(() {
      _cardFlips[index] = true;

      // Comprobar si es la primera o segunda tarjeta volteada en un par
      if (_previousCardIndex == -1) {
        _previousCardIndex = index;
      } else {
        _canFlip = false;
        _showHint();

        // Retardo de 1 segundo para mostrar ambas tarjetas
        Timer(Duration(seconds: 1), () {
          if (_cards[_previousCardIndex] == _cards[index]) {
            // Coincidencia encontrada
            _cardFlips[_previousCardIndex] = true;
            _cardFlips[index] = true;
            _pairsFound++;

            if (_pairsFound == _cards.length ~/ 2) {
              // Se encontraron todas las parejas, mostrar el cuadro de diálogo de fin de juego
              _showGameOverDialog();
            }
          } else {
            // No hay coincidencia, voltear las tarjetas de nuevo
            _cardFlips[_previousCardIndex] = false;
            _cardFlips[index] = false;
          }

          _previousCardIndex = -1;
          _canFlip = true;
        });
      }
    });
  }

  void _showHint() {
    setState(() {
      _showingHint = true;
    });

    Timer(Duration(seconds: 1), () {
      setState(() {
        _showingHint = false;
      });
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  '¡Felicitaciones!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 12),
                Text('Has encontrado todas las parejas.'),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _pairsFound = 0;
                          _initializeCards();
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Volver a jugar'),
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
            title: Text('MEMORAMA'),
          ),
          body: Visibility(
            visible: !_showDifficultyDialog,
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _cards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (BuildContext context, int index) {
                            //return _buildCard(index);

                return GestureDetector(
                  onTap: () => _flipCard(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 247, 245, 245) ,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _showingHint || _cardFlips[index]
                        ? Image.asset(_cards[index])
                        : Icon(Icons.help, size: 48),
                  ),
                );
              },
            ),
            replacement: Center(
              child: ElevatedButton(
                onPressed: _showDifficultySelectionDialog,
                child: Text('Seleccionar dificultad'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTourDialog() {
    showDialog(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido al Memorama',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '¡Adivina las parejas de tarjetas iguales para ganar el juego!',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  '1. Haz clic en una tarjeta para voltearla.',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '2. Si dos tarjetas tienen la misma imagen, ¡has encontrado una pareja!',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '3. Si no coinciden, las tarjetas se volverán a voltear después de 1 segundo.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Cerrar el cuadro de diálogo
                      },
                      child: Text('Empezar'),
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

  // Widget _buildCard(int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       _flipCard(index);
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: _cardFlips[index] ? Colors.white : Colors.blue,
  //         borderRadius: BorderRadius.circular(8.0),
  //       ),
  //       child: _showingHint || _cardFlips[index]
  //           ? Image.asset(_cards[index])
  //           : Icon(Icons.help, size: 48),
  //     ),
  //   );
  // }
}
