import 'package:delphino_app/models/lecciones.dart';
import 'package:flutter/material.dart';
import 'package:delphino_app/models/usuario.dart';

import '../models/subniveles.dart';

class UserProvider with ChangeNotifier {
  Usuario? _user;

  Usuario? get user => _user;

  void setUser(Usuario? user) {
    if (user != null) {
      _user = Usuario(
        uid: user.uid,
        email: user.email ?? '',
        nombre: user.nombre ?? '',
        photoUrl: user.photoUrl ?? '',
        progreso: user.progreso ?? Progreso(),
      );
    } else {
      _user = null;
    }
    notifyListeners();
  }

  void completarSubnivel(Subnivel subnivel) {
    if (_user != null) {
      // Obtener el progreso actual del usuario
      Progreso progreso = _user!.progreso ?? Progreso();

      // Marcar el subnivel como completado en el progreso
      progreso.marcarSubnivelComoCompletado(subnivel);

      // Actualizar el progreso del usuario
      _user!.progreso = progreso;

      // Realizar cualquier otra acción necesaria, como guardar el progreso en la base de datos

      // Notificar a los listeners que el usuario ha sido actualizado
      notifyListeners();
    }
  }

   void completarLeccion(Leccion leccion) {
    //if (_user != null) {
      // Obtener el progreso actual del usuario
      Progreso progreso = _user!.progreso ?? Progreso();

      // Marcar leccion como completado en el progreso
      progreso.marcarLeccionComoCompletada(leccion);

      // Actualizar el progreso del usuario
      _user!.progreso = progreso;

      // Realizar cualquier otra acción necesaria, como guardar el progreso en la base de datos

      // Notificar a los listeners que el usuario ha sido actualizado
      notifyListeners();
    //}
  }
}
