import 'package:delphino_app/models/preguntas.dart';

class Leccion {
  List<Pregunta> preguntas;
  int? id;
  String? imageUrl;
  String? identificador;
  bool? leccionCompletada;

  String nombre;
  Leccion(
      {required this.nombre,
      this.id,
      this.imageUrl,
      required this.preguntas,
      this.identificador});

  Map<String, dynamic> toMap() {
    final map = {
      'nombre': nombre,
      'leccionCompletada': leccionCompletada,
    };

    if (id != null) {
      map['id'] = id;
    }

    if (identificador != null) {
      map['identificador'] = identificador;
    }

    if (preguntas.isNotEmpty) {
      map['preguntas'] = preguntas.map((pregunta) => pregunta.toMap()).toList();
    }

    return map;
  }

  // void marcarLeccionCompletada() {
  //   leccionCompletada = true;
  //   // Aquí puedes realizar cualquier otra lógica adicional, como guardar el estado en una base de datos o notificar a otros componentes sobre el cambio.
  // }
}
