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
}
