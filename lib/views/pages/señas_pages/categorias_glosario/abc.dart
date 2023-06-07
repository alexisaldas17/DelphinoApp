import 'package:flutter/material.dart';

class ABCPage extends StatefulWidget {
  const ABCPage({Key? key}) : super(key: key);

  @override
  State<ABCPage> createState() => _ABCPageState();
}

class _ABCPageState extends State<ABCPage> {
  List<String> alphabet = List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

  // Lista de colores para los botones
  List<Color> buttonColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.cyan,
    Colors.amber,
    Colors.indigo,
    Colors.lime,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.deepPurple,
    Colors.lightGreen,
    Colors.brown,
    // Agrega más colores si es necesario
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Número de columnas
      ),
      itemCount: alphabet.length,
      itemBuilder: (context, index) {
        final letter = alphabet[index];
        final buttonColor = buttonColors[index % buttonColors.length]; // Asigna un color de la lista en base al índice

        return ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Letra seleccionada: $letter')),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: buttonColor, // Asigna el color al botón
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/letters/letter_$letter.png', // Ruta de la imagen para cada letra
                width: 50,
                height: 50,
              ),
              SizedBox(height: 10),
              Text(
                letter,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
