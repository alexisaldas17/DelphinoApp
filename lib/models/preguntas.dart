class Pregunta {
  int id;
  String? imagen;
  String enunciado;
  List<String> opciones;
  String respuestaCorrecta;

  Pregunta(
      {required this.id,
      this.imagen,
      required this.enunciado,
      required this.opciones,
      required this.respuestaCorrecta});
}
