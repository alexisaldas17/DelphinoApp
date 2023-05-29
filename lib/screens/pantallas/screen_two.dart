import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth.service.dart';

class ScreenTwo extends StatefulWidget {
  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  final AuthService _auth = AuthService();
  User? _user; // Usuario actualmente autenticado
  @override
  void initState() {
    super.initState();
    // Obtener el usuario actualmente autenticado al iniciar la pantalla
    _user = _auth.getCurrentUser();
  }
  // void _handleSignOut(BuildContext context) async {
  //   await _auth.signOut();
  //   // Redireccionar a la página de inicio de sesión
  //   Navigator.pushReplacementNamed(context, '/login');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(_user!.photoURL ?? ''),
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
              onPressed: () {},
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
