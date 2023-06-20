class Diccionario {
  String id;
  String uid;
  String palabra;
  String senia;
  String imagen;
  String categoria;
  String? descripcion;

  Diccionario(
      {required this.id,
      required this.uid,
      required this.palabra,
      required this.senia,
      required this.imagen,
      required this.categoria,
      this.descripcion});

  factory Diccionario.fromJson(Map<String, dynamic> json) {
    return Diccionario(
      id: json['id'],
      uid: json['uid'],
      palabra: json['palabra'],
      senia: json['seña'],
      imagen: json['imagen'],
      categoria: json['categoria'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'palabra': palabra,
      'seña': senia,
      'imagen': imagen,
      'categoria': categoria,
      'descripcion': descripcion
    };
  }
}
