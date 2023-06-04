import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../controllers/diccionario_controller.dart';

class AnimalesPage extends StatefulWidget {
  const AnimalesPage({Key? key}) : super(key: key);

  @override
  State<AnimalesPage> createState() => _AnimalesPageState();
}

class _AnimalesPageState extends State<AnimalesPage> {
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

  DiccionarioController _diccionarioService = DiccionarioController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _diccionarioService
          .getWordsByCategory('animales'), // Filtrar por la categoría 'frutas'
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
        }
        if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Muestra un mensaje de error si ocurre algún problema
        }
        List<DocumentSnapshot>? animalesDocuments = snapshot.data;
        if (animalesDocuments == null || animalesDocuments.isEmpty) {
          return Text(
              'No se encontraron animales.'); // Muestra un mensaje si no se encuentran frutas
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Número de columnas
          ),
          itemCount: animalesDocuments.length,
          itemBuilder: (context, index) {
            final animalSnapshot = animalesDocuments[index];
            final animalData = animalSnapshot.data() as Map<String, dynamic>;
            final animalNombre = animalData['palabra'] as String;
            final animalImagen = animalData['imagen'] as String;
            final buttonColor = buttonColors[index %
                buttonColors
                    .length]; // Asigna un color de la lista en base al índice

            return ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Animal seleccionado: $animalNombre')),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: buttonColor, // Asigna el color al botón
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (animalImagen.isNotEmpty)
                    Image.network(
                      animalImagen, // URL de la imagen para cada fruta
                      width: 50,
                      height: 50,
                    )
                  else
                    Icon(Icons
                        .image_not_supported), // Widget alternativo cuando la URL está vacía
                  SizedBox(height: 10),
                  Text(
                    animalNombre,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
