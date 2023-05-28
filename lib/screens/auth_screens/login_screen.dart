import 'package:delphino_app/screens/auth_screens/registro_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../../services/auth.service.dart';
import '../home_screen.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  late FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // late FirebaseAuth _auth;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  void _handleSignIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validar que los campos de correo electrónico y contraseña no estén vacíos
    if (email.isNotEmpty && password.isNotEmpty) {
      UserCredential? userCredential =
          await authService.signIn(email, password);

      // ignore: unnecessary_null_comparison
      if (userCredential != null) {
        // El inicio de sesión fue exitoso, redireccionar a la siguiente pantalla
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // El inicio de sesión falló, mostrar mensaje de error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content:
                  Text('Inicio de sesión fallido. Verifica tus credenciales.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      setState(() {
        _auth = FirebaseAuth.instance;
      });
    });
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Aquí puedes realizar alguna acción después del inicio de sesión exitoso
      print('Inicio de sesión exitoso: ${userCredential.user?.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Usuario no encontrado');
      } else if (e.code == 'wrong-password') {
        print('Contraseña incorrecta');
      }
      // Aquí puedes mostrar un mensaje de error al usuario
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /////TEXTFORMFIELD CORREO/////
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Correo',
                  prefixIcon: Icon(Icons.email),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            /////TEXTFORMFIELD CONTRASEÑA/////

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Lógica para el restablecimiento de contraseña
                },
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(fontSize: 16.0, color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            ///////////////BOTONES//////////////

            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(
                    255, 78, 74, 74), // Color de fondo del botón
                padding: EdgeInsets.symmetric(
                    horizontal: 185.0, vertical: 18.0), // Tamaño del botón
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(8.0),
                // ),
              ),
              child: const Text(
                'Ingresar',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 40.0), // Espacio vertical entre los elementos

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'O ingresar con',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Expanded(
                  child: Divider(),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /////////////BOTON INGRESO GOOGLE////////

                ElevatedButton(
                  onPressed: () async {
                    final authService = AuthService();
                    final userCredential = await authService.signInWithGoogle();
                    // ignore: unnecessary_null_comparison
                    if (userCredential != null) {
                      // El usuario ha iniciado sesión correctamente
                      // Realiza las acciones necesarias, como navegación a una nueva pantalla
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      // Error en el inicio de sesión
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Color de fondo del botón
                    padding: EdgeInsets.all(16.0), // Tamaño del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Image.asset(
                    'assets/google_logo.png',
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
                SizedBox(width: 16.0), // Espacio horizontal entre los elementos

                /////////////BOTON INGRESO IPHONE////////
                ElevatedButton(
                  onPressed: () {
                    // Lógica para ingresar con iCloud
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Color de fondo del botón
                    padding: EdgeInsets.all(16.0), // Tamaño del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Image.asset(
                    'assets/apple_iphone.png',
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0), // Espacio vertical entre los elementos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Lógica para la acción de "Registrate ahora"
                  },
                  child: Text(
                    '¿No estás registrado?',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),

                SizedBox(height: 8.0), // Espacio vertical entre los elementos
                TextButton(
                  onPressed: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                  },
                  child: Text(
                    
                    'Registrar ahora',
                    style: TextStyle(fontSize: 16.0, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
