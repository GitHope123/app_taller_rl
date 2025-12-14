class User {
  final String id;
  final String nombre;
  final String apellidos;
  final String rol;
  final String dni;
  final String celular;

  User({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.rol,
    required this.dni,
    required this.celular,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_usuario'] ?? '',
      nombre: json['nombre'] ?? '',
      apellidos: json['apellidos'] ?? '',
      rol: json['rol'] ?? '',
      dni: json['dni'] ?? '',
      celular: json['celular'] ?? '',
    );
  }
}
