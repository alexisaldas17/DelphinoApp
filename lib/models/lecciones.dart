import 'package:delphino_app/models/preguntas.dart';

class Leccion {
  List<Pregunta> preguntas;
  int? id;
  String? identificador;
  bool? leccionCompletada;

  String nombre;
  Leccion({
    required this.nombre,
    this.id,
    required this.preguntas,
    this.identificador
  });

  // void marcarLeccionCompletada() {
  //   leccionCompletada = true;
  //   // Aquí puedes realizar cualquier otra lógica adicional, como guardar el estado en una base de datos o notificar a otros componentes sobre el cambio.
  // }
}
