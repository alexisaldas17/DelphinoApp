class Pregunta {
  int id;
  String? idLeccion;
  String? imagen;
  String enunciado;
  List<String> opciones;
  dynamic respuestaCorrecta;
  String? tipo;
  Pregunta(
      {required this.id,
      this.idLeccion,
      this.imagen,
      required this.enunciado,
      required this.opciones,
      required this.respuestaCorrecta,
      this.tipo});

    Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'enunciado': enunciado,
      'opciones': opciones,
      'respuestaCorrecta': respuestaCorrecta,
    };

    if (idLeccion != null) {
      map['idLeccion'] = idLeccion;
    }

    if (imagen != null) {
      map['imagen'] = imagen;
    }

    if (tipo != null) {
      map['tipo'] = tipo;
    }

    return map;
  }
}
