import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:delphino_app/views/auth_screens/login_screen.dart';

import '../controllers/auth_controller.dart';

class ScreenFive extends StatefulWidget {
  @override
  State<ScreenFive> createState() => _ScreenFiveState();
}

class _ScreenFiveState extends State<ScreenFive> {
  final AuthController _auth = AuthController();
  User? _user; // Usuario actualmente autenticado
  @override
  void initState() {
    super.initState();
    // Obtener el usuario actualmente autenticado al iniciar la pantalla
    _user = _auth.getCurrentUser();
  }

//Metodo para Cerrar Sesion
  void _handleSignOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Redireccionar a la página de inicio de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Manejo de errores
      print('Error al cerrar sesión: $e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Se produjo un error al cerrar sesión.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Cerrar el diálogo
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.network(
                  _user!.photoURL ??
                      'https://firebasestorage.googleapis.com/v0/b/delphinoapp.appspot.com/o/perfil.png?alt=media&token=296aedc6-c28f-4033-8833-f46b53f25bc0',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '¡Bienvenido a tu perfil!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Nombre de usuario'),
                subtitle: Text(_user!.displayName ?? 'N/A'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('Correo electrónico'),
                subtitle: Text(_user!.email ?? 'N/A'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.code),
                title: Text('UID'),
                subtitle: Text(_user!.uid),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _handleSignOut(context),
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
