import 'package:delphino_app/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({required this.child});

  Future<bool> isAuthenticated() async {
    // Aquí puedes realizar la lógica para verificar si el usuario está autenticado y autorizado
    // Puedes utilizar SharedPreferences para almacenar el estado de inicio de sesión

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isAuthenticated(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          // El usuario está autenticado, muestra la pantalla Home
          return child;
        } else {
          // El usuario no está autenticado, muestra la página de inicio de sesión
          return WelcomePage();
        }
      },
    );
  }
}
