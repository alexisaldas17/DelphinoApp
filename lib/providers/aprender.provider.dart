import 'package:flutter/material.dart';
import '../../../controllers/aprender_controller.dart';

import '../models/lecciones.dart';
import '../models/niveles.dart';
import '../models/subniveles.dart';

class AprenderProvider with ChangeNotifier {
  List<Nivel>? _niveles;

  List<Nivel>? get niveles => _niveles;

  void setNivel(List<Nivel> niveles) {
    if (_niveles != null) {
      _niveles = niveles;
    }
    notifyListeners();
  }

  Future<void> aprobarSubnivel(Subnivel subnivel) async {
    try {
      // Verificar si el subnivel ya está aprobado
      if (subnivel.subnivelAprobado == true) {
        return;
      }

      // Actualizar la propiedad subnivelAprobado del subnivel
      subnivel.subnivelAprobado = true;

      // Notificar a los listeners del provider
      notifyListeners();

      // Guardar los cambios en Firebase (si es necesario)
      // ...
    } catch (error) {
      print('Error al aprobar el subnivel: $error');
    }
  }

bool todasLeccionesCompletadas(
  Subnivel subnivel, List<Leccion> leccionesCompletadas) {
  // Verificar si todas las lecciones están completadas
  bool todasCompletadas = subnivel.lecciones
      .every((leccion) => leccionesCompletadas.contains(leccion));

  if (todasCompletadas) {
    // Buscar el índice del subnivel en la lista de subniveles del nivel actual
    //int currentIndex =
       // niveles[currentNivelIndex].subniveles.indexOf(subnivel);

    // Verificar si el subnivel actual no es el último de la lista
    // if (currentIndex < niveles[currentNivelIndex].subniveles.length - 1) {
    //   // Obtener el siguiente subnivel de la lista
    //   Subnivel siguienteSubnivel =
    //       niveles[currentNivelIndex].subniveles[currentIndex + 1];

    //   // Asignar el valor de subnivelAprobado = true al siguiente subnivel si es nulo
    //   siguienteSubnivel.subnivelAprobado ??= true;
    // }
    //return true;
  }
  return false;
}

  Future<void> obtenerNivelesDesdeFirebase() async {
    try {
      AprenderController aprenderController = AprenderController();
      _niveles = await aprenderController.getNiveles();
      // Asignar los niveles al provider
      _niveles = niveles;

      // Notificar a los listeners del provider
      notifyListeners();
    } catch (error) {
      // Manejar cualquier error de forma apropiada (mostrar un mensaje, registrar en el log, etc.)
      print('Error al obtener los niveles desde Firebase: $error');
    }
  }
}
