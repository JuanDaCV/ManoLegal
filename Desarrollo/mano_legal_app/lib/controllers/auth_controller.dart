import 'package:sqflite/sqflite.dart';
import '../models/cliente_model.dart';
import '../models/abogado_model.dart';
import 'db_helper.dart';

class AuthController {
  final _dbHelper = DatabaseHelper.instance;

  Future<bool> registerCliente(Cliente cliente) async {
    final db = await _dbHelper.database;
    try {
      await db.insert(
        'clientes',
        cliente.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return true;
    } catch (e) {
      // Generalmente falla por UNIQUE constraint de correo
      return false;
    }
  }

  Future<bool> registerAbogado(Abogado abogado) async {
    final db = await _dbHelper.database;
    try {
      await db.insert(
        'abogados',
        abogado.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> login(String correo, String contrasena) async {
    final db = await _dbHelper.database;

    // Buscar en clientes
    final List<Map<String, dynamic>> resClientes = await db.query(
      'clientes',
      where: 'correo = ? AND contrasena = ?',
      whereArgs: [correo, contrasena],
    );

    if (resClientes.isNotEmpty) {
      return {'tipo': 'cliente', 'datos': Cliente.fromMap(resClientes.first)};
    }

    // Buscar en abogados
    final List<Map<String, dynamic>> resAbogados = await db.query(
      'abogados',
      where: 'correo = ? AND contrasena = ?',
      whereArgs: [correo, contrasena],
    );

    if (resAbogados.isNotEmpty) {
      return {'tipo': 'abogado', 'datos': Abogado.fromMap(resAbogados.first)};
    }

    return null; // Credenciales incorrectas
  }
}
