import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('manolegal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullable = 'TEXT';
    const integerType = 'INTEGER';

    await db.execute('''
CREATE TABLE clientes (
  id $idType,
  nombres $textType,
  apellidos $textType,
  fecha_nacimiento $textType,
  correo $textType UNIQUE,
  contrasena $textType
  )
''');

    await db.execute('''
CREATE TABLE abogados (
  id $idType,
  nombres $textType,
  apellidos $textType,
  fecha_nacimiento $textType,
  correo $textType UNIQUE,
  contrasena $textType,
  foto_perfil $textNullable,
  especialidad $textNullable,
  anos_experiencia $integerType,
  tarifa $textNullable,
  sobre_ti $textNullable,
  doc_cedula $textNullable,
  doc_tarjeta_profesional $textNullable,
  doc_sirna $textNullable,
  doc_diploma $textNullable,
  doc_antecedentes $textNullable,
  estado_verificado TEXT NOT NULL DEFAULT 'false'
  )
''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
