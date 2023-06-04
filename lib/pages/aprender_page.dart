import 'package:flutter/material.dart';

class AprenderPage extends StatefulWidget {
  const AprenderPage({Key? key}) : super(key: key);

  @override
  State<AprenderPage> createState() => _AprenderPageState();
}

class _AprenderPageState extends State<AprenderPage> {
  List<int> niveles = [1, 2, 3, 4, 5]; // Lista de niveles
  Map<int, List<String>> temasPorNivel = { // Mapa que contiene los temas para cada nivel
    1: ['ABC 1', 'ABC 2', 'ABC 3','SALUDOS 1', 'VIDEO LECCION', 'VERBOS 1', 'EXÁMEN 1'],
    2: ['Tema 4', 'Tema 5', 'Tema 6'],
    3: ['Tema 7', 'Tema 8', 'Tema 9'],
    4: ['Tema 10', 'Tema 11', 'Tema 12'],
    5: ['Tema 13', 'Tema 14', 'Tema 15'],
  };

  List<IconData> icons = [
    Icons.book,
    Icons.brush,
    Icons.computer,
    Icons.sports,
    Icons.music_note,
    Icons.movie,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aprender'),
      ),
      body: ListView.builder(
        itemCount: niveles.length,
        itemBuilder: (context, index) {
          final nivel = niveles[index];
          final temas = temasPorNivel[nivel] ?? []; // Obtiene la lista de temas para el nivel actual

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color.fromARGB(255, 104, 83, 223),
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Nivel $nivel',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: temas.map((tema) {
                    final iconIndex = temas.indexOf(tema) % icons.length;
                    final icon = icons[iconIndex];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Material(
                            shape: CircleBorder(),
                            elevation: 2,
                            child: Ink(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  icon,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Acción al seleccionar el tema
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Tema seleccionado: $tema')),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            tema,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
