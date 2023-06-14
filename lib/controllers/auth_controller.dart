import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delphino_app/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../i18n/LocalizedMessages .dart';
import '../providers/user.provider.dart';

class AuthController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _errorMessage;

  Future<UserCredential?> signInWithGoogle(
    BuildContext context,
  ) async {
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

      // Almacena las credenciales en la colección "usuarios"
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('usuarios');
      final DocumentReference userDocument =
          usersCollection.doc(userCredential.user!.uid);

// Comprueba si el documento del usuario ya existe
      final DocumentSnapshot userSnapshot = await userDocument.get();
      if (!userSnapshot.exists) {
        // El documento del usuario no existe, crea uno nuevo
        await userDocument.set({
          'uid': userCredential.user!.uid,
          'nombre': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'imagenUrl': userCredential.user!.photoURL,
          // Otras propiedades que desees almacenar
        });
      }
// Obtén los datos del usuario desde Firestore
      final DocumentSnapshot updatedUserSnapshot = await userDocument.get();
      if (updatedUserSnapshot.exists) {
        final Map<String, dynamic> userData =
            updatedUserSnapshot.data() as Map<String, dynamic>;
        // Mapear los datos del documento en un objeto Usuario
        Usuario usuario = Usuario(
          nombre: userData['nombre'] ?? '',
          uid: userData['uid'] ?? '',
          email: userData['email'] ?? '',
          photoUrl: userData['imagenUrl'] ?? '',
        );

        // Actualiza el estado del usuario en UserProvider
        final UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(usuario);
      }

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

      // Almacenar los datos en la colección "usuarios" de Firestore
      if (userCredential.user != null) {
        await _firestore
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .set({
          'id': userCredential.user!.uid,
          'nombre': name,
          'email': email,
          'contraseña': password,
          'rol': 'usuario',
          'fecha_creacion': DateTime.now(),
        });
      }

      return userCredential;
    } catch (e) {
      // Manejo de errores
      _errorMessage = e.toString(); // Capturar el mensaje de error
      return null;
    }
  }

  Future<UserCredential?> signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtener el documento del usuario utilizando Firestore
      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .get();

      // Aquí puedes acceder a los datos del documento del usuario
      if (userDocument.exists) {
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;
        // Hacer algo con los datos del usuario
        // Mapear los datos del documento en un objeto Usuario
        Usuario usuario = Usuario(
          nombre: userData['nombre'] ?? '',
          uid: userData['id'] ?? '',
          email: userData['email'] ?? '',
          rol: userData['rol'] ?? '',
        );

        final UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(usuario);
        print('Datos del usuario: $userData');
      } else {
        // El documento del usuario no existe
        print('El documento del usuario no existe');
      }

      return userCredential;
    } catch (e) {
      // Manejo de errores
      print('Error durante el inicio de sesión: $e');
      return null;
    }
  }

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

class AuthControllerProvider extends StatelessWidget {
  final Widget child;

  const AuthControllerProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (context) => AuthController(),
      child: child,
    );
  }
}
