import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class AppMessages {
  static String errorMessage(String code) {
    debugPrint(code);
    switch (code) {
      case '[firebase_auth/invalid-email] The email address is badly formatted.':
        return Intl.message('Dirección de correo inválida',
            name: 'errorMessage_invalidEmail');
      case '[firebase_auth/weak-password] Password should be at least 6 characters':
        return Intl.message('Contraseña débil',
            name: 'errorMessage_weakPassword');
      case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
        return Intl.message('Correo ya está en uso',
            name: 'errorMessage_emailInUse');
      // Agrega más casos para otros códigos de error que desees manejar
      default:
        return Intl.message('Un error a ocurrido',
            name: 'errorMessage_generic');
    }
  }
}
