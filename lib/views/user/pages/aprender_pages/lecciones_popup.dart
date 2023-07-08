import 'dart:ui';

import 'package:delphino_app/controllers/aprender_controller.dart';
import 'package:delphino_app/controllers/auth_controller.dart';
import 'package:delphino_app/controllers/users_controller.dart';
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

  // bool todasLasLeccionesAprobadas() {
  //   UserProvider userProvider = UserProvider();
  //   final leccionesAprobadas = lecciones.every((leccion) {
  //     final leccionAprobada = userProvider.user!.progreso!.leccionesCompletadas
  //             .any((leccionCompletada) =>
  //                 leccionCompletada.identificador == leccion.identificador) ??
  //         false;
  //     return leccionAprobada;
  //   });

  //   return leccionesAprobadas;
  // }

  @override
  Widget build(BuildContext context) {
    // UserController userController = UserController();
    // AuthController authController = AuthController();
    // final todasAprobadas = todasLasLeccionesAprobadas();
    // if (todasAprobadas) {
    //   userController.actualizarSubnivelesCompletados(
    //       authController.getCurrentUser()!.uid, widget.subnivel);
    // }
    final userProvider = Provider.of<UserProvider>(context);
    final progreso = userProvider.user?.progreso;

    return Container(
      height: 200,
      child: Material(
        child: Column(
          children: [
            Text('Tema seleccionado: ${widget.subnivel.nombre}'),
            Expanded(
              child: lecciones.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: lecciones.length,
                      itemBuilder: (context, index) {
                        final leccion = lecciones[index];
                        final leccionAprobada = progreso?.leccionesCompletadas
                                .any((leccionCompletada) =>
                                    leccionCompletada.identificador ==
                                    leccion.identificador) ??
                            false;

                        return GestureDetector(
                          onTap: () {
                            final preguntas = leccion.preguntas;

                            if (leccion.preguntas.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Lección sin preguntas'),
                                  content: Text(
                                      'Aún no existen preguntas en la lección seleccionada.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Aceptar'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LeccionPage(
                                    subnivel: widget.subnivel,
                                    preguntas: preguntas,
                                    leccion: leccion,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              margin: EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        leccion.imageUrl != null
                                            ? Image.network(
                                                leccion.imageUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/default_image.png',
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              )
                                            : Container(),
                                        if (leccionAprobada)
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    leccion.nombre,
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      final preguntas = leccion.preguntas;
                                      if (leccion.preguntas.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                Text('Lección sin preguntas'),
                                            content: Text(
                                                'Aún no existen preguntas en la lección seleccionada.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Aceptar'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LeccionPage(
                                              subnivel: widget.subnivel,
                                              preguntas: preguntas,
                                              leccion: leccion,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text('Iniciar'),
                                  ),
                                ],
                              ),
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
