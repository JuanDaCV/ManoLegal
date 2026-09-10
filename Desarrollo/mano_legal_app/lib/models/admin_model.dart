class Admin {
  final String correo;
  final String contrasena;
  final String rol;

  const Admin({
    required this.correo,
    required this.contrasena,
    this.rol = 'admin',
  });

  static const defaultAdmin = Admin(
    correo: 'admin@lexconnect.com',
    contrasena: 'Admin2024*',
  );
}
