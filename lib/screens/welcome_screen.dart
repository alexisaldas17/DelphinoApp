import 'package:delphino_app/screens/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'auth_screens/registro_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Bienvenida'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/splash.jpg', // Ruta de la imagen del logo
              height: 80.0,
              width: 80.0,
            ),
            SizedBox(height: 16.0),
            Image.asset(
              'assets/welcome.JPG', // Ruta de la imagen de bienvenida
              height: 400.0,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.0),
            Text(
              '¡Bienvenido a Delphino App!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Lógica para el botón "Ingresar"
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ));
              },
              child: Text('Ingresar'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                // Lógica para el botón "Registrar"
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => RegisterPage(),
                    ));
                
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
