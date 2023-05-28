import 'package:delphino_app/screens/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ajusta el tiempo en milisegundos
    const splashDuration = Duration(seconds: 4);

    // Navega a la siguiente pantalla después del tiempo especificado
    Future.delayed(splashDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
      );
    });
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9, // Ajusta el valor según la relación de aspecto deseada
          child: Container(
            width: 200, // Ajusta el ancho deseado
            height: 200, // Ajusta la altura deseada
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('assets/splash.jpg'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset('assets/splash.jpg'),
          ),
          ),
          
        ),
      ),
    );
    
  }
}
