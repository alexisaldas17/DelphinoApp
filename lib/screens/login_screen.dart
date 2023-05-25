import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth.service.dart';
import 'home_screen.dart';
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
        title: const Text('Inicio de sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
            ),
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
              child: Image.asset(
                'assets/google_logo.png',
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
