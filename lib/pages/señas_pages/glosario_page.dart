import 'package:flutter/material.dart';

import 'categorias_glosario/abc.dart';
import 'categorias_glosario/animales.dart';
import 'categorias_glosario/frutas.dart';

class GlosarioPage extends StatefulWidget {
  @override
  _GlosarioPageState createState() => _GlosarioPageState();
}

class _GlosarioPageState extends State<GlosarioPage> {
  List<Widget> contenidoCategorias = [
    ABCPage(),
    FrutasPage(), 
    AnimalesPage(),
    Text('Contenido Números'),
    // ... Agrega más widgets para las demás categorías
  ];
  List<String> categorias = [
    'ABC',
    'Frutas',
    'Animales',
    'Números',
    'Descripciones Físicas',
    'Saludos',
    'Verbos',
    'Días',
    'Meses',
    'Familia',
    'Colores',
    'Expresiones',
    'Objetos',
    'Preguntas',
    'Adjetivos',
    'Preposiciones',
    'Pronombres'
  ];
  ScrollController _scrollController = ScrollController();
  int selectedButtonIndex = 0;

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.offset - 200,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              Text(
                'Categorías',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.offset + 200,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 100, // Ajusta la altura del ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: categorias.length,
              itemExtent: 125, // Ajusta el ancho de cada elemento del ListView
              itemBuilder: (context, index) {
                String categoria = categorias[index];
                Color buttonColor = buttonColors[index %
                    buttonColors
                        .length]; // Asigna un color de la lista en base al índice

                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedButtonIndex =
                            index; // Actualiza el índice del botón seleccionado
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: buttonColor, // Asigna el color al botón
                    ),
                    child: Text(categoria),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: contenidoCategorias[selectedButtonIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
