class Diccionario {
  String id;
  String palabra;
  String senia;
  String imagen;
  String categoria;

  Diccionario({required this.id, required this.palabra, required this.senia,required this.imagen, required this.categoria});

  factory Diccionario.fromJson(Map<String, dynamic> json) {
    return Diccionario(
      id: json['id'],
      palabra: json['palabra'],
      senia: json['seña'],
      imagen: json['imagen'],
      categoria: json['categoria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'palabra': palabra,
      'seña': senia,
      'imagen': imagen,
      'categoria': categoria,
    };
  }
}
