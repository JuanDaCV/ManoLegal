class Cliente {
  int? id;
  String nombres;
  String apellidos;
  String fechaNacimiento;
  String correo;
  String contrasena;

  Cliente({
    this.id,
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.correo,
    required this.contrasena,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'fecha_nacimiento': fechaNacimiento,
      'correo': correo,
      'contrasena': contrasena,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      fechaNacimiento: map['fecha_nacimiento'],
      correo: map['correo'],
      contrasena: map['contrasena'],
    );
  }
}
