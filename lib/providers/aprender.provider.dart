import 'package:flutter/material.dart';

import '../models/niveles.dart';

class AprenderProvider with ChangeNotifier {
  Nivel? _nivel;

  Nivel? get nivel => _nivel;

  void setNivel(Nivel? nivel) {
    if (nivel != null) {
      _nivel = Nivel(
          id: nivel.id, 
          nombre: nivel.nombre, 
          subniveles: nivel.subniveles
          );
    } else {
      _nivel = null;
    }
    notifyListeners();
  }
}
