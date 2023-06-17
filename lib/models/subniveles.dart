import 'lecciones.dart';

class Subnivel {
  int id;
  List<Leccion> lecciones;
  String? nombre;
  String urlImage;
  bool? subnivelAprobado;

  Subnivel(
      {
      required this.id,
      this.nombre,
      required this.lecciones,
      required this.urlImage,
      this.subnivelAprobado
      //this.aprobado
      });

      Map<String, dynamic> toMap() {
    final map = {
      'nombre': nombre,
     // 'lecciones': lecciones.map((leccion) => leccion.toMap()).toList(),
      'subnivelAprobado': subnivelAprobado,
    };
      if (nombre != null) {
      map['nombre'] = nombre;
    }

    if (id != null || id != 0 ) {
      map['id'] = id;
    }
    if (urlImage.isNotEmpty) {
      map['urlImage'] = urlImage;
    }
    if (lecciones.isNotEmpty) {
      map['lecciones'] = lecciones.map((leccion) => leccion.toMap()).toList();
    }


    return map;
  }
}
