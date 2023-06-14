import 'lecciones.dart';

class Subnivel {
  int id;
  List<Leccion> lecciones;
  String nombre;
  String urlImage;
  bool? subnivelAprobado;

  Subnivel({
    required this.id,
    required this.nombre,
    required this.lecciones,
    required this.urlImage,
    this.subnivelAprobado
    //this.aprobado
  });
}
