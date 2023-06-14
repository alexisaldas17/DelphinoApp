import 'package:delphino_app/models/niveles.dart';
import 'package:delphino_app/models/subniveles.dart';

import 'lecciones.dart';

class Usuario {
  String uid;
  String nombre;
  String? apellido;
  String email;
  String? contrasenia;
  String? rol;
  DateTime? fecha_creacion;
  String? photoUrl;
  Progreso? progreso;
  Usuario(
      {required this.uid,
      required this.nombre,
      this.photoUrl,
      this.apellido,
      required this.email,
      this.contrasenia,
      this.rol,
      this.fecha_creacion,
      this.progreso});
}

class Progreso {
  int? id;
  String? uidUsuario;
  List<Nivel>? niveles;
  // bool? nivel1;
  // bool? nivel2;
  // bool? nivel3;

  //Progreso({this.id, this.uidUsuario, this.niveles});

  List<Subnivel> subnivelesCompletados;
  List<Leccion> leccionesCompletadas;

  Progreso(
      {List<Subnivel>? subnivelesCompletados,
      List<Leccion>? leccionesCompletadas})
      : subnivelesCompletados = subnivelesCompletados ?? [],
        leccionesCompletadas = leccionesCompletadas ?? [];

  void marcarSubnivelComoCompletado(Subnivel subnivel) {
    if (!subnivelesCompletados.contains(subnivel)) {
      subnivelesCompletados.add(subnivel);
    }
  }

  void marcarLeccionComoCompletada(Leccion leccion) {
    if (!leccionesCompletadas.contains(leccion)) {
      leccion.leccionCompletada = true;
      leccionesCompletadas.add(leccion);
    }
  }
}
