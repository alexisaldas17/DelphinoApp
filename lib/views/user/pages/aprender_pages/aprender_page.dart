import 'package:delphino_app/providers/aprender.provider.dart';
import 'package:delphino_app/providers/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lecciones_popup.dart';

class AprenderPage extends StatefulWidget {
  const AprenderPage({Key? key}) : super(key: key);

  @override
  State<AprenderPage> createState() => _AprenderPageState();
}

class _AprenderPageState extends State<AprenderPage> {
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

    final progreso = userProvider.user?.progreso;
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
                      // final subnivelAprobado = subnivel.subnivelAprobado;
                      final subnivelAprobado = progreso?.subnivelesCompletados
                              .any((subnivelCompletado) =>
                                  subnivelCompletado.nombre ==
                                  subnivel.nombre) ??
                          false;

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
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.warning,
                                            color: Colors.orange,
                                            size: 48,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Subnivel no aprobado',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Este subnivel no está aprobado. Completa los requisitos previos para desbloquearlo.',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 16),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cerrar'),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                  fontSize: 17,
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
