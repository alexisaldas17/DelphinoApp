import 'package:delphino_app/controllers/auth_controller.dart';
import 'package:delphino_app/views/auth_screens/loginAdmin_screen.dart';
import 'package:delphino_app/views/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'gestion_palabras/agregar_palabra.dart';
import 'gestion_palabras/diccionario.dart';

class HomeAdministrador extends StatefulWidget {
  @override
  _HomeAdministradorState createState() => _HomeAdministradorState();
}

class _HomeAdministradorState extends State<HomeAdministrador> {
  bool _isDrawerOpen = false;

  void _handleDrawerState(bool isOpened) {
    setState(() {
      _isDrawerOpen = isOpened;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Administrador'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Menú',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionTile(
                    title: Text('Gestionar Palabras'),
                    children: [
                      ListTile(
                        title: Text('Agregar Palabra'),
                        onTap: () {
                          // Lógica para manejar la selección de la subopción 1
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AgregarPalabra()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Editar Palabra'),
                        onTap: () {
                          Navigator.pop(context);

                          // Lógica para manejar la selección de la subopción 2
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditarDiccionario()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Borrar Palabra'),
                        onTap: () {
                          // Lógica para manejar la selección de la subopción 2
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  // ExpansionTile(
                  //   title: Text('Gestionar Glosario'),
                  //   children: [
                  //     ListTile(
                  //       title: Text('Categoria ABC'),
                  //       onTap: () {
                  //         // Lógica para manejar la selección de la subopción 1
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //     ListTile(
                  //       title: Text('Categoria Números'),
                  //       onTap: () {
                  //         // Lógica para manejar la selección de la subopción 2
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //     ListTile(
                  //       title: Text('Categoria Colores'),
                  //       onTap: () {
                  //         // Lógica para manejar la selección de la subopción 2
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //     ListTile(
                  //       title: Text('Categoria Animales'),
                  //       onTap: () {
                  //         // Lógica para manejar la selección de la subopción 2
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //     ListTile(
                  //       title: Text('Categoria Frutas'),
                  //       onTap: () {
                  //         // Lógica para manejar la selección de la subopción 2
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //     ListTile(
                  //       title: Text('Categoria Objetos'),
                  //       onTap: () {
                  //         // Lógica para manejar la selección de la subopción 2
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //     ListTile(
                  //       title: Text('Categoria Días'),
                  //       onTap: () {
                  //         // Lógica para manejar la selección de la subopción 2
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //     ListTile(
                  //       title: Text('Categoria Meses'),
                  //       onTap: () {
                  //         // Lógica para manejar la selección de la subopción 2
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              leading: Icon(Icons.logout),
              onTap: () {
                AuthController authController = AuthController();
                authController.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
                // Lógica para cerrar sesión
              },
            ),
          ],
        ),
      ),
 body: Builder(
  builder: (BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          if (_isDrawerOpen) {
            Scaffold.of(context).openEndDrawer();
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Acción del primer botón
                },
                icon: Icon(Icons.add),
                label: Text('AGREGAR PALABRA'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Acción del segundo botón
                },
                icon: Icon(Icons.edit),
                label: Text('EDITAR PALABRA'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Acción del tercer botón
                },
                icon: Icon(Icons.delete),
                label: Text('BORRAR PALABRA'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
),


    );
  }
}
