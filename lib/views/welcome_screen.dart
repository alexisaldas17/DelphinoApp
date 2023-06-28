import 'package:delphino_app/views/auth_screens/loginEstudiante_screen.dart';
import 'package:delphino_app/views/auth_screens/loginAdmin_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/auth_controller.dart';
import 'home_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
    final FluroRouter router = FluroRouter();
  List<String> carouselImages = [
    'assets/welcome1.png',
    'assets/welcome2.png',
    // 'assets/image3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 58, 180, 224),
                  Color.fromARGB(255, 246, 247, 250),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 80.0,
                width: 80.0,
              ),
              SizedBox(height: 16.0),
              Text(
                '¡Bienvenido a Delphino App!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              CarouselSlider(
                items: carouselImages.map((imagePath) {
                  return Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 400.0,
                  viewportFraction: 0.9,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.easeInOut,
                  pauseAutoPlayOnTouch: true,
                  enlargeCenterPage: true,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () async {
                  final authService = AuthController();
                  final userCredential =
                      await authService.signInWithGoogle(context);
                  // ignore: unused_local_variable

                  // ignore: unnecessary_null_comparison
                  if (userCredential != null) {
                   
                    Navigator.pushReplacementNamed(
                      context,'/home'
                     
                    );
                    
                    // Realiza las acciones necesarias con los datos del usuario
                  } else {
                    // Error en el inicio de sesión
                    String errorMessage = 'Error durante el ingreso';
                    if (authService.getErrorMessage(context) != null) {
                      errorMessage = authService.getErrorMessage(context)!;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                icon: Image.asset(
                  'assets/google_logo.png',
                  height: 24,
                  width: 24,
                ),
                label: Text('Ingresar con Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton.icon(
                
                onPressed: () {
              
               router.navigateTo(context, '/protected', transition: TransitionType.fadeIn);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) => LoginAdmin(),
                  //   ),
                  // );
                },
                icon: Image.asset(
                  'assets/apple_iphone.png',
                  width: 24,
                  height: 24,
                ),
                label: Text('Ingresar con Apple ID'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  // Lógica para dirigirse a una nueva página al hacer clic
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginAdmin(),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    '¿Eres administrador?',
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 0, 0, 0), // Color del texto en azul
                      decoration:
                          TextDecoration.underline, // Subrayado del texto
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
