import 'lecciones.dart';

class Subnivel {
  int id;
  List<Leccion> lecciones;
  String nombre;
  String urlImage;

  Subnivel({
    required this.id,
    required this.nombre,
    required this.lecciones,
    required this.urlImage,
  });
}
