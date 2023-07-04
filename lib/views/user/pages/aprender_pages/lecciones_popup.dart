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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeccionPage(
                                  preguntas: preguntas,
                                  leccion: leccion,
                                ),
                              ),
                            );
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LeccionPage(
                                            preguntas: preguntas,
                                            leccion: leccion,
                                          ),
                                        ),
                                      );
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



// import 'package:delphino_app/models/subniveles.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../../models/lecciones.dart';
// import '../../../../providers/user.provider.dart';
// import 'leccion_page.dart';

// class BottomPopup extends StatefulWidget {
//   final Subnivel subnivel;

//   const BottomPopup({required this.subnivel});

//   @override
//   State<BottomPopup> createState() => _BottomPopupState();
// }

// class _BottomPopupState extends State<BottomPopup> {
//   late List<Leccion> lecciones;

//   @override
//   void initState() {
//     super.initState();
//     lecciones = widget.subnivel.lecciones;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider =
//         Provider.of<UserProvider>(context); // Acceder a UserProvider
//     final progreso =
//         userProvider.user?.progreso; // Obtener el progreso del usuario

//     return Container(
//       height: 300,
//       child: Material(
//         child: Column(
//           children: [
//             Text('Tema seleccionado: ${widget.subnivel.nombre}'),
//             Expanded(
//               child: lecciones.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: lecciones.length,
//                       itemBuilder: (context, index) {
//                         final leccion = lecciones[index];

//                         // Verificar si la lección está aprobada
//                         final leccionAprobada = progreso?.leccionesCompletadas
//                                 .any((leccionCompletada) =>
//                                     leccionCompletada.identificador ==
//                                     leccion.identificador) ??
//                             false;
//                         return GestureDetector(
//                           onTap: () {
//                             // Obtener la lista de preguntas de la lección
//                             final preguntas = leccion.preguntas;
//                                                     Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => LeccionPage(
//                                     preguntas: preguntas, leccion: leccion),
//                               ),
//                             );
//                           },
//                           child: Dismissible(
//                             key: Key(leccion.id.toString()),
//                             direction: DismissDirection.endToStart,
//                             onDismissed: (direction) {
//                               setState(() {
//                                 lecciones.removeAt(index);
//                               });
//                             },
//                             background: Container(
//                               alignment: Alignment.centerRight,
//                               color: Colors.red,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 16),
//                                 child: Icon(
//                                   Icons.delete,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             child: ListTile(
//                               title: Text(leccion.nombre),
//                               trailing: leccionAprobada
//                                   ? Icon(Icons.check, color: Colors.green)
//                                   : null,
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   : Center(
//                       child: Text('No hay lecciones disponibles.'),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
