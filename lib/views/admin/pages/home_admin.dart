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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
                      MaterialPageRoute(builder: (context) => AgregarPalabra()),
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

            ExpansionTile(
              title: Text('Gestionar Glosario'),
              children: [
                ListTile(
                  title: Text('Categoria ABC'),
                  onTap: () {
                    // Lógica para manejar la selección de la subopción 1
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Categoria Números'),
                  onTap: () {
                    // Lógica para manejar la selección de la subopción 2
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Categoria Colores'),
                  onTap: () {
                    // Lógica para manejar la selección de la subopción 2
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Categoria Animales'),
                  onTap: () {
                    // Lógica para manejar la selección de la subopción 2
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Categoria Frutas'),
                  onTap: () {
                    // Lógica para manejar la selección de la subopción 2
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Categoria Objetos'),
                  onTap: () {
                    // Lógica para manejar la selección de la subopción 2
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Categoria Días'),
                  onTap: () {
                    // Lógica para manejar la selección de la subopción 2
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Categoria Meses'),
                  onTap: () {
                    // Lógica para manejar la selección de la subopción 2
                    Navigator.pop(context);
                  },
                ),
              ],
            ),

            // Agrega más opciones de menú según tus necesidades
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
                child: Text('Contenido principal'),
              ),
            ),
          );
        },
      ),
    );
  }
}
