import 'package:flutter/material.dart';

import '../../services/auth.service.dart';


class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  final AuthService _auth = AuthService();

  void _handleSignOut(BuildContext context) async {
    await _auth.signOut();
    // Redireccionar a la página de inicio de sesión
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido a tu perfil!',
              style: TextStyle(fontSize: 24),
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
