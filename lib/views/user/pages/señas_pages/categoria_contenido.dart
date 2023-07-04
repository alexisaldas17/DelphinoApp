import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delphino_app/controllers/diccionario_controller.dart';
import 'package:delphino_app/models/palabra.dart';
import 'package:flutter/material.dart';

import 'categorias_popup.dart';

class CategoriaContenido extends StatefulWidget {
  String nombreCategoria;
  CategoriaContenido({required this.nombreCategoria});
  @override
  State<CategoriaContenido> createState() => _CategoriaContenidoState();
}

class _CategoriaContenidoState extends State<CategoriaContenido> {
  bool isLoading = true;

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
      future: _diccionarioService.getWordsByCategory(
          widget.nombreCategoria.isNotEmpty
              ? widget.nombreCategoria.toLowerCase()
              : 'abc'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && isLoading) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          isLoading = false;
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        List<DocumentSnapshot>? abcDocuments = snapshot.data;
        if (abcDocuments == null || abcDocuments.isEmpty) {
          return Text(
              'Aún no existen palabras para la Categoría ${widget.nombreCategoria}.');
        }

        // Ordenar la lista en orden alfabético
        abcDocuments.sort((a, b) {
          final palabraA = a['palabra'] as String;
          final palabraB = b['palabra'] as String;
          return palabraA.compareTo(palabraB);
        });
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Número de columnas
          ),
          itemCount: abcDocuments.length,
          itemBuilder: (context, index) {
            final snapshot = abcDocuments[index];
            final data = snapshot.data() as Map<String, dynamic>;
            final nombre = data['palabra'] as String;
            final imagen = data['imagen'] as String;
            final buttonColor = buttonColors[index %
                buttonColors
                    .length]; // Asigna un color de la lista en base al índice
            final palabra = Palabra(
                uid: data['uid'] ?? '',
                palabra: nombre ?? '',
                categoria: data['categoria'] ?? '',
                imagen: imagen ?? '',
                senia: data['seña'] ?? '',
                descripcion: data['descripcion'] ?? '');

            return ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CategoriaPopup(palabra: palabra);
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // Asigna el color al botón
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imagen.isNotEmpty
                      ? Image.network(
                          imagen,
                          width: 50,
                          height: 50,
                        )
                      : imagen != ""
                          ? Icon(Icons.image_not_supported)
                          : SizedBox(height: 10),
                  Text(
                    nombre,
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
