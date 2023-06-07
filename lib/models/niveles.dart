import 'package:delphino_app/models/subniveles.dart';

class Nivel {
  int id; // Nueva propiedad para el ordenamiento
  String nombre;

  List<Subnivel> subniveles;

  Nivel({
    required this.id,
    required this.nombre,
    required this.subniveles,
  });
}
