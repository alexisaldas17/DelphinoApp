import 'package:delphino_app/models/preguntas.dart';

class Leccion {
  List<Pregunta> preguntas;
  int id;
  String nombre;
  Leccion({required this.nombre, required this.id, required this.preguntas});
}
