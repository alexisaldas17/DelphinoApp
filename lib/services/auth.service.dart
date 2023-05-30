import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../i18n/LocalizedMessages .dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _errorMessage;

  Future<UserCredential?> signInWithGoogle() async {
    // Configura las opciones de inicio de sesión con Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    try {
      // Crea una credencial de acceso con Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión con la credencial en Firebase
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      // Manejo de errores
      _errorMessage = e.toString(); // Capturar el mensaje de error
      return null;
    }
  }

  User? getCurrentUser() {
    User? user = _firebaseAuth.currentUser;
    return user;
  }

  String? getErrorMessage(BuildContext context) {
    if (_errorMessage != null) {
      return LocalizedMessages.errorMessage(context, _errorMessage!);
    }
    return null;
  }

  Future<UserCredential?> signUp(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Asignar nombre de usuario
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
      }

      return userCredential;
    } catch (e) {
      // Manejo de errores
      _errorMessage = e.toString(); // Capturar el mensaje de error
      return null;
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      // Manejo de errores
      print('Error durante el inicio de sesión: $e');
      return null;
    }
  }

  // Future<void> signOut() async {
  //   await _firebaseAuth.signOut();
  // }

  // // Cerrar sesión con Google
  // Future<void> signOutGoogle() async {
  //   try {
  //     await _googleSignIn.signOut();
  //   } catch (e) {
  //     print('Error al cerrar sesión con Google: $e');
  //   }
  // }
  Future<void> signOut() async {
     try {
    // Cerrar sesión en Firebase
    await _firebaseAuth.signOut();

    // Cerrar sesión con Google
    await _googleSignIn.signOut();
  } catch (e) {
    // Manejo de errores
    _errorMessage = e.toString();
    print('Error al cerrar sesión: $_errorMessage');
    throw Exception(_errorMessage);
  }
  }
 
}
