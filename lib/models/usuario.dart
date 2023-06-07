class Usuario {
  int id;
  String nombre;
  String apellido;
  String email;
  String contrasenia;
  String rol;
  DateTime fecha_creacion;
  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.contrasenia,
    required this.rol,
    required this.fecha_creacion,
  });
}
