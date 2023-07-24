import 'package:delphino_app/controllers/auth_controller.dart';
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
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/perfil.png'), // Reemplaza 'ruta_de_la_imagen' con la ruta de la imagen de administrador
                            radius:
                                30, // Ajusta el tamaño del círculo de la imagen
                          ),
                          SizedBox(
                              height: 8), // Espacio entre la imagen y el texto
                          Text(
                            'Administrador',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
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
                        title: Text('Actualizar Palabra'),
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
                      // ListTile(
                      //   title: Text('Borrar Palabra'),
                      //   onTap: () {
                      //     // Lógica para manejar la selección de la subopción 2
                      //     Navigator.pop(context);
                      //   },
                      // ),
                    ],
                  ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgregarPalabra()),
                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text('AGREGAR PALABRA'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        fixedSize: MaterialStateProperty.all<Size>(Size.square(
                            160)), // Ajusta el tamaño del botón a un cuadrado de 100x100
                      ),
                    ),
                    SizedBox(height: 32),

                    ElevatedButton.icon(
                      onPressed: () {
                        // Acción del segundo botón
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditarDiccionario()),
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text('ACTUALIZAR PALABRA'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        fixedSize: MaterialStateProperty.all<Size>(Size.square(
                            160)), // Ajusta el tamaño del botón a un cuadrado de 100x100
                      ),
                    ),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     // Acción del tercer botón
                    //   },
                    //   icon: Icon(Icons.delete),
                    //   label: Text('BORRAR PALABRA'),
                    //   style: ButtonStyle(
                    //     backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    //   ),
                    // ),
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
