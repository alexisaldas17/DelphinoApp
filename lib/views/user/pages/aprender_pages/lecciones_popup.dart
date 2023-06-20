import 'package:delphino_app/models/subniveles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/lecciones.dart';
import '../../../../providers/user.provider.dart';
import 'leccion_page.dart';

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
    final userProvider =
        Provider.of<UserProvider>(context); // Acceder a UserProvider
    final progreso =
        userProvider.user?.progreso; // Obtener el progreso del usuario

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

                        // Verificar si la lección está aprobada
                        final leccionAprobada = progreso?.leccionesCompletadas
                                .any((leccionCompletada) =>
                                    leccionCompletada.identificador ==
                                    leccion.identificador) ??
                            false;

                        // progreso?.leccionesCompletadas.contains(leccion.identificador) ??
                        //     false;

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
                                    preguntas: preguntas, leccion: leccion),
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
                              trailing: leccionAprobada
                                  ? Icon(Icons.check, color: Colors.green)
                                  : null,
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
