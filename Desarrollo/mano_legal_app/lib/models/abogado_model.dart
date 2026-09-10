class Abogado {
  int? id;
  String nombres;
  String apellidos;
  String fechaNacimiento;
  String correo;
  String contrasena;
  String? fotoPerfil;
  String? especialidad;
  int? anosExperiencia;
  String? tarifa;
  String? sobreTi;
  String? docCedula;
  String? docTarjetaProfesional;
  String? docSirna;
  String? docDiploma;
  String? docAntecedentes;
  String estadoVerificado;

  Abogado({
    this.id,
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.correo,
    required this.contrasena,
    this.fotoPerfil,
    this.especialidad,
    this.anosExperiencia,
    this.tarifa,
    this.sobreTi,
    this.docCedula,
    this.docTarjetaProfesional,
    this.docSirna,
    this.docDiploma,
    this.docAntecedentes,
    this.estadoVerificado = 'false',
  });

  bool get verificado => estadoVerificado.toLowerCase() == 'true';
  set verificado(bool value) => estadoVerificado = value ? 'true' : 'false';
  String get verificadoLabel => verificado ? 'Verificado' : 'No verificado';

  List<String> get documentosSubidos {
    final docs = <String>[];
    if (docCedula != null) docs.add('Cédula');
    if (docTarjetaProfesional != null) docs.add('Tarjeta');
    if (docSirna != null) docs.add('Sirna');
    if (docDiploma != null) docs.add('Diploma');
    if (docAntecedentes != null) docs.add('Antecedentes');
    return docs;
  }

  String get documentosResumen => documentosSubidos.isEmpty
      ? 'Sin documentos'
      : documentosSubidos.join(', ');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'fecha_nacimiento': fechaNacimiento,
      'correo': correo,
      'contrasena': contrasena,
      'foto_perfil': fotoPerfil,
      'especialidad': especialidad,
      'anos_experiencia': anosExperiencia,
      'tarifa': tarifa,
      'sobre_ti': sobreTi,
      'doc_cedula': docCedula,
      'doc_tarjeta_profesional': docTarjetaProfesional,
      'doc_sirna': docSirna,
      'doc_diploma': docDiploma,
      'doc_antecedentes': docAntecedentes,
      'estado_verificado': estadoVerificado,
    };
  }

  factory Abogado.fromMap(Map<String, dynamic> map) {
    return Abogado(
      id: map['id'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      fechaNacimiento: map['fecha_nacimiento'],
      correo: map['correo'],
      contrasena: map['contrasena'],
      fotoPerfil: map['foto_perfil'],
      especialidad: map['especialidad'],
      anosExperiencia: map['anos_experiencia'],
      tarifa: map['tarifa'],
      sobreTi: map['sobre_ti'],
      docCedula: map['doc_cedula'],
      docTarjetaProfesional: map['doc_tarjeta_profesional'],
      docSirna: map['doc_sirna'],
      docDiploma: map['doc_diploma'],
      docAntecedentes: map['doc_antecedentes'],
      estadoVerificado: map['estado_verificado'] ?? 'false',
    );
  }
}
