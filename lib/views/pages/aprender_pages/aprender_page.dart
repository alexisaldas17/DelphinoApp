// import 'package:delphino_app/models/niveles.dart';
// import 'package:delphino_app/providers/user.provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../controllers/aprender_controller.dart';
// import '../../../views/pages/aprender_pages/lecciones_popup.dart';

// class AprenderPage extends StatefulWidget {
//   const AprenderPage({Key? key}) : super(key: key);

//   @override
//   State<AprenderPage> createState() => _AprenderPageState();
// }

// class _AprenderPageState extends State<AprenderPage> {

//   AprenderController _aprenderController = AprenderController();
//   @override
//   void initState() {
//     super.initState();
//     _aprenderController.getNiveles();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserProvider>(builder: (context, userProvider, _) {
//       // Acceder a la variable user de UserProvider
//       final user = userProvider.user;

//       return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false, // Mostrar la flecha hacia atrás
//           title: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: user!.photoUrl != null
//                     ? NetworkImage(user!.photoUrl!)
//                     : null,
//                 child: user!.photoUrl == null ? Text(user!.nombre![0]) : null,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 user.nombre ?? 'Usuario',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//         body: StreamBuilder<List<Nivel>>(
//           stream: _aprenderController
//               .nivelesStream, // Reemplazar por tu propio Stream

//           // future: _aprenderController.getNiveles(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error al cargar los niveles'));
//             }
//             final niveles = snapshot.data ?? [];

//             return ListView.builder(
//               itemCount: niveles.length,
//               itemBuilder: (context, index) {
//                 final nivel = niveles[index];

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       color: Color.fromARGB(255, 104, 83, 223),
//                       padding: const EdgeInsets.all(16.0),
//                       child: Center(
//                         child: Text(
//                           '${nivel.nombre}',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: nivel.subniveles.map((subnivel) {
//                           // final iconIndex = nivel.subniveles.indexOf(subnivel);

//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 showModalBottomSheet(
//                                   context: context,
//                                   builder: (BuildContext context) =>
//                                       BottomPopup(subnivel: subnivel),
//                                 );
//                               },
//                               child: Column(
//                                 children: [
//                                   Material(
//                                     shape: CircleBorder(),
//                                     elevation: 2,
//                                     child: Ink(
//                                       width: 80,
//                                       height: 80,
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: ClipOval(
//                                         child: Image.network(
//                                           subnivel.urlImage,
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                             return Image.asset(
//                                               'assets/images/default_image.png',
//                                               fit: BoxFit.cover,
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     subnivel.nombre,
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       );
//     });
//   }
// }
// import 'package:delphino_app/models/niveles.dart';
// import 'package:delphino_app/providers/aprender.provider.dart';
// import 'package:delphino_app/providers/user.provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../controllers/aprender_controller.dart';
// import '../../../views/pages/aprender_pages/lecciones_popup.dart';

// class AprenderPage extends StatefulWidget {
//   const AprenderPage({Key? key}) : super(key: key);

//   @override
//   State<AprenderPage> createState() => _AprenderPageState();
// }

// class _AprenderPageState extends State<AprenderPage> {
//   //late AprenderProvider _aprenderProvider =Provider.of<AprenderProvider>(context, listen: false);
//   AprenderController _aprenderController = AprenderController();

//   @override
//   void initState() {
//     super.initState();
//     _aprenderController.getNiveles(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AprenderProvider>(builder: (context, aprenderProvider, _) {
//       // Acceder a la variable user de UserProvider
//       UserProvider userProvider =
//           Provider.of<UserProvider>(context, listen: false);
//       final user = userProvider.user;

//       return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false, // Mostrar la flecha hacia atrás
//           title: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: user!.photoUrl != null
//                     ? NetworkImage(user!.photoUrl!)
//                     : null,
//                 child: user!.photoUrl == null ? Text(user!.nombre![0]) : null,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 user.nombre ?? 'Usuario',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//         body: StreamBuilder<List<Nivel>>(
//           stream: _aprenderController
//               .nivelesStream, // Reemplazar por tu propio Stream

//           // future: _aprenderController.getNiveles(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error al cargar los niveles'));
//             }
//             final niveles = snapshot.data ?? [];

//             return ListView.builder(
//               itemCount: niveles.length,
//               itemBuilder: (context, index) {
//                 final nivel = niveles[index];

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       color: Color.fromARGB(255, 104, 83, 223),
//                       padding: const EdgeInsets.all(16.0),
//                       child: Center(
//                         child: Text(
//                           '${nivel.nombre}',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: nivel.subniveles.map((subnivel) {
//                           final bool? subnivelAprobado =
//                               subnivel.subnivelAprobado;

//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 if (subnivelAprobado!) {
//                                   showModalBottomSheet(
//                                     context: context,
//                                     builder: (BuildContext context) =>
//                                         BottomPopup(subnivel: subnivel),
//                                   );
//                                 } else {
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                         title: Text('Subnivel no aprobado'),
//                                         content: Text(
//                                             'Este subnivel no está aprobado. Completa los requisitos previos para desbloquearlo.'),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: Text('Cerrar'),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 }
//                               },
//                               child: Column(
//                                 children: [
//                                   Material(
//                                     shape: CircleBorder(),
//                                     elevation: 2,
//                                     child: Ink(
//                                       width: 80,
//                                       height: 80,
//                                       decoration: BoxDecoration(
//                                         color: subnivelAprobado!
//                                             ? Colors.blue
//                                             : Colors.grey,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: ClipOval(
//                                         child: Image.network(
//                                           subnivel.urlImage,
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                             return Image.asset(
//                                               'assets/images/default_image.png',
//                                               fit: BoxFit.cover,
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     subnivel.nombre,
//                                     style: TextStyle(
//                                       color: subnivelAprobado
//                                           ? Colors.black
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       );
//     });
//   }
// }
import 'package:delphino_app/models/niveles.dart';
import 'package:delphino_app/providers/aprender.provider.dart';
import 'package:delphino_app/providers/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/aprender_controller.dart';
import '../../../models/lecciones.dart';
import '../../../models/subniveles.dart';
import '../../../views/pages/aprender_pages/lecciones_popup.dart';

class AprenderPage extends StatefulWidget {
  const AprenderPage({Key? key}) : super(key: key);

  @override
  State<AprenderPage> createState() => _AprenderPageState();
}

class _AprenderPageState extends State<AprenderPage> {
    int currentNivelIndex = 0; // Debes inicializarlo con el valor correcto
  @override
  void initState() {
    super.initState();
    Provider.of<AprenderProvider>(context, listen: false)
        .obtenerNivelesDesdeFirebase();
    // _aprenderController.getNiveles();
  }

  @override
  Widget build(BuildContext context) {
    // Acceder a la variable user de UserProvider
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Mostrar la flecha hacia atrás
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
              child:
                  user?.photoUrl == null ? Text(user?.nombre?[0] ?? '') : null,
            ),
            SizedBox(width: 8),
            Text(
              user?.nombre ?? 'Usuario',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Consumer<AprenderProvider>(builder: (context, provider, _) {
        final niveles = provider.niveles;

        // if (niveles == null || niveles.isEmpty) {
        //   return Center(child: Text('No se encontraron niveles.'));
        // }
        if (niveles == null) {
          // Muestra un indicador de carga o un mensaje mientras se cargan los niveles desde Firebase
          return Center(child: CircularProgressIndicator());
        } else if (niveles.isEmpty) {
          // Muestra un mensaje cuando no hay niveles disponibles
          return Center(child: Text('No se encontraron niveles.'));
        }

        return ListView.builder(
          itemCount: niveles.length,
          itemBuilder: (context, index) {
            final nivel = niveles[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Color.fromARGB(255, 104, 83, 223),
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      '${nivel.nombre}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: nivel.subniveles.map((subnivel) {
                      final bool? subnivelAprobado = subnivel.subnivelAprobado;
                      final bool todasLeccionesCompletas =
                          provider.todasLeccionesCompletadas(
                              subnivel, user!.progreso!.leccionesCompletadas);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (subnivelAprobado == true) {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) =>
                                    BottomPopup(subnivel: subnivel),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Subnivel no aprobado'),
                                    content: todasLeccionesCompletas
                                        ? Text(
                                            '¡Felicidades! Has completado todas las lecciones de este subnivel.')
                                        : Text(
                                            'Este subnivel no está aprobado. Completa los requisitos previos para desbloquearlo.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cerrar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Material(
                                shape: CircleBorder(),
                                elevation: 2,
                                child: Ink(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: subnivelAprobado == true
                                        ? Colors.blue
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      subnivel.urlImage,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/default_image.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                subnivel.nombre ?? '',
                                style: TextStyle(
                                  color: subnivelAprobado == true
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
