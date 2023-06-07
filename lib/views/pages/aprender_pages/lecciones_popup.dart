import 'package:delphino_app/models/subniveles.dart';
import 'package:flutter/material.dart';

import '../../../models/lecciones.dart';
import '../../../models/preguntas.dart';
import '../../../views/pages/aprender_pages/leccion_page.dart'; // Importa la página LeccionPage

class BottomPopup extends StatefulWidget {
  final Subnivel subnivel;

  const BottomPopup({required this.subnivel});

  @override
  State<BottomPopup> createState() => _BottomPopupState();
}

class _BottomPopupState extends State<BottomPopup> {
  late List<Leccion> lecciones;

  @override
  void initState() {
    super.initState();
    lecciones = widget.subnivel.lecciones;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Material(
        child: Column(
          children: [
            Text('Tema seleccionado: ${widget.subnivel.nombre}'),
            Expanded(
              child: lecciones.isNotEmpty
                  ? ListView.builder(
                      itemCount: lecciones.length,
                      itemBuilder: (context, index) {
                        final leccion = lecciones[index];

                        return GestureDetector(
                          onTap: () {
                            // Obtener la lista de preguntas de la lección
                            final preguntas = leccion.preguntas;
                            // Crear una lista temporal de preguntas
                            // List<Pregunta> listaPreguntas = [];
                            // for (Pregunta pregunta in preguntas) {
                            //   listaPreguntas.add(pregunta);
                            // }
                            // Navegar a la página de la lección al hacer clic en ella
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeccionPage(
                                  preguntas: preguntas,
                                ),
                              ),
                            );
                          },
                          child: Dismissible(
                            key: Key(leccion.id.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                lecciones.removeAt(index);
                              });
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Text(leccion.nombre),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text('No hay lecciones disponibles.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
