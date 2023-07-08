import 'package:delphino_app/controllers/aprender_controller.dart';
import 'package:delphino_app/controllers/auth_controller.dart';
import 'package:delphino_app/controllers/users_controller.dart';
import 'package:delphino_app/models/lecciones.dart';
import 'package:delphino_app/providers/aprender.provider.dart';
import 'package:flutter/material.dart';
import 'package:delphino_app/models/usuario.dart';

import '../models/niveles.dart';
import '../models/subniveles.dart';

class UserProvider with ChangeNotifier {
  Usuario? _user;

  Usuario? get user => _user;
  AprenderProvider aprenderProvider = AprenderProvider();
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

  // void completarSubnivel(Subnivel subnivel) {
  //   if (_user != null) {
  //     // Obtener el progreso actual del usuario
  //     Progreso progreso = _user!.progreso ?? Progreso();

  //     // Marcar el subnivel como completado en el progreso
  //     progreso.marcarSubnivelComoCompletado(subnivel);

  //     // Actualizar el progreso del usuario
  //     _user!.progreso = progreso;

  //     // Realizar cualquier otra acción necesaria, como guardar el progreso en la base de datos

  //     // Notificar a los listeners que el usuario ha sido actualizado
  //     notifyListeners();
  //   }
  // }

  void completarLeccion(Leccion leccion) {
    if (_user != null) {
      // Obtener el progreso actual del usuario
      Progreso? progreso = _user!.progreso ?? Progreso();

      // Marcar leccion como completado en el progreso
      progreso!.marcarLeccionComoCompletada(leccion);

      // Actualizar el progreso del usuario
      _user!.progreso = progreso;

      // Realizar cualquier otra acción necesaria, como guardar el progreso en la base de datos
      UserController userController = UserController();
      if (_user != null && _user!.progreso != null) {
        // Agregar verificación adicional
        userController.actualizarLeccionesCompletadas(_user!.uid, leccion);
      }
      // Notificar a los listeners que el usuario ha sido actualizado
      notifyListeners();
    }
  }

  void completarSubnivel(Subnivel subnivel) {
    if (_user != null) {
      // Obtener el progreso actual del usuario
      Progreso? progreso = _user!.progreso ?? Progreso();

      // Marcar leccion como completado en el progreso
      progreso!.marcarSubnivelComoCompletado(subnivel);

      // Actualizar el progreso del usuario
      _user!.progreso = progreso;

      // Realizar cualquier otra acción necesaria, como guardar el progreso en la base de datos
      UserController userController = UserController();
      if (_user != null && _user!.progreso != null) {
        // Agregar verificación adicional
        userController.actualizarSubnivelesCompletados(_user!.uid, subnivel);
      }
      // Notificar a los listeners que el usuario ha sido actualizado
      notifyListeners();
    }
  }

//   bool verificarLeccionesCompletadas(
//       Subnivel subnivel, List<Leccion> leccionesCompletadas) {
//     if (_user != null) {
//       List<Leccion> leccionesSubnivel = subnivel.lecciones;

//       for (var leccion in leccionesSubnivel) {
//         if (!leccionesCompletadas.any((leccionCompletada) =>
//             leccionCompletada.identificador == leccion.identificador)) {
//           return false;
//         }
//       }
//       AprenderProvider aprenderProvider = AprenderProvider();
//       aprenderProvider.aprobarSubnivel(subnivel);
//     }

//     return true;
//   }
  bool verificarLeccionesCompletadas(
    Subnivel subnivel,
    List<Leccion> leccionesCompletadas,
    List<Subnivel> subniveles,
  ) {
    if (_user != null) {
      List<Leccion> leccionesSubnivel = subnivel.lecciones;

      for (var leccion in leccionesSubnivel) {
        if (!leccionesCompletadas.any((leccionCompletada) =>
            leccionCompletada.identificador == leccion.identificador)) {
          return false;
        }
      }

      // Verificar si todas las lecciones del nivel actual están completadas
      bool todasLeccionesCompletas =
          subniveles.any((s) => s.nombre == subnivel.nombre);

      if (todasLeccionesCompletas) {
        // Obtener el siguiente subnivel en la lista
        int currentIndex = subniveles.indexOf(subnivel);
        if (currentIndex < subniveles.length - 1) {
          Subnivel siguienteSubnivel = subniveles[currentIndex + 1];

          // Asignar el valor true al siguiente subnivel si no está aprobado
          if (siguienteSubnivel.subnivelAprobado != true) {
            AprenderProvider aprenderProvider = AprenderProvider();
            aprenderProvider.aprobarSubnivel(siguienteSubnivel);
          }
        }
      }
    }

    return true;
  }

  bool todasLasLeccionesDelSubnivelCompletadas(
      Subnivel subnivel, Nivel? nivel) {
    if (_user != null) {
      final List<Leccion> leccionesCompletadas =
          _user!.progreso!.leccionesCompletadas;
      List<Leccion> leccionesSubnivel = subnivel.lecciones;

      for (var leccion in leccionesSubnivel) {
        if (!leccionesCompletadas.any((leccionCompletada) =>
            leccionCompletada.identificador == leccion.identificador)) {
          return false;
        }
      }

      // Todas las lecciones del subnivel están completadas
      UserController userController = UserController();
      AprenderProvider aprenderProvider = AprenderProvider();

      // Actualizar el subnivel actual aprobado
      // aprenderProvider.aprobarSubnivel(subnivel);
      // completarSubnivel(subnivel);

      // Obtener el siguiente subnivel
      // Nivel? nivel = aprenderProvider.obtenerNivelDelSubnivel(subnivel);
      if (nivel != null) {
        int subnivelIndex = nivel.subniveles.indexOf(subnivel);
        subnivelIndex = subnivelIndex == -1 ? 0 : subnivelIndex;
        int siguienteSubnivelIndex = subnivelIndex + 1;
        if (siguienteSubnivelIndex < nivel.subniveles.length) {
          Subnivel siguienteSubnivel = nivel.subniveles[siguienteSubnivelIndex];
          aprenderProvider.aprobarSubnivel(siguienteSubnivel);
          completarSubnivel(siguienteSubnivel);

          // Actualizar el siguiente subnivel como aprobado
          userController.actualizarSubnivelesCompletados(
              _user!.uid, siguienteSubnivel);
        }
      }
    }
    return true;
  }
//   Nivel? obtenerNivelDelSubnivel(Subnivel subnivel) {
//   final List<Nivel>? niveles = niveles;
//   if (niveles != null) {
//     for (var nivel in niveles) {
//       for (var nivelSubnivel in nivel.subniveles) {
//         if (nivelSubnivel == subnivel) {
//           return nivel;
//         }
//       }
//     }
//   }
//   return null;
// }
}
