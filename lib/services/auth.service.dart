import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
 final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    // Configura las opciones de inicio de sesión con Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Crea una credencial de acceso con Google
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Inicia sesión con la credencial en Firebase
    final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential;
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      // Manejo de errores
      print('Error durante el registro: $e');
      return null;
    }
  }
    Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
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
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  // Cerrar sesión con Google
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error al cerrar sesión con Google: $e');
    }
  }
}
