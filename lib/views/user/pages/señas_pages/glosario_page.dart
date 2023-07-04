import 'package:delphino_app/controllers/diccionario_controller.dart';
import 'package:flutter/material.dart';

import '../../../../models/categoria.dart';
import 'categoria_contenido.dart';

class GlosarioPage extends StatefulWidget {
  @override
  _GlosarioPageState createState() => _GlosarioPageState();
}

class _GlosarioPageState extends State<GlosarioPage> {
  List<Categoria> categorias = []; // Lista de categorías

  @override
  void initState() {
    super.initState();
    // Llama al método para obtener todas las categorías al iniciar la página
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    DiccionarioController diccionarioController = DiccionarioController();
    // Llama al método para obtener todas las categorías
    List<Categoria> allCategories =
        await diccionarioController.getAllCategories();

    // Ordenar las categorías alfabéticamente por nombre
    allCategories.sort((a, b) => a.nombre.compareTo(b.nombre));

    setState(() {
      categorias = allCategories;
    });
  }

  ScrollController _scrollController = ScrollController();
  int selectedButtonIndex = 0;
  String categoriaSeleccionada = '';
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
                String categoriaNombre = categorias[index].nombre;
                Color buttonColor = buttonColors[index %
                    buttonColors
                        .length]; // Asigna un color de la lista en base al índice

                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        categoriaSeleccionada = categorias[index].nombre;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor, // Asigna el color al botón
                    ),
                    child: Text(categoriaNombre),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child:
                    CategoriaContenido(nombreCategoria: categoriaSeleccionada),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
