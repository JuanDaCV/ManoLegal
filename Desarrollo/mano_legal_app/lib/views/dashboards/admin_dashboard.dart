import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/abogado_model.dart';
import '../../models/cliente_model.dart';
import '../theme/app_theme.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _authController = AuthController();
  late Future<void> _loadFuture;
  List<Cliente> _clientes = [];
  List<Abogado> _abogados = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadData();
  }

  Future<void> _loadData() async {
    final clientes = await _authController.getAllClientes();
    final abogados = await _authController.getAllAbogados();
    setState(() {
      _clientes = clientes;
      _abogados = abogados;
    });
  }

  Future<void> _toggleVerification(Abogado abogado) async {
    setState(() => _isLoading = true);
    final success = await _authController.updateAbogadoVerification(
      abogado.id!,
      !abogado.verificado,
    );
    if (success) {
      setState(() {
        abogado.estadoVerificado = (!abogado.verificado).toString();
      });
    }
    setState(() => _isLoading = false);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo actualizar la verificación')),
      );
    }
  }

  Widget _buildClientesTable() {
    if (_clientes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('No hay clientes registrados aún.'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Correo')),
          DataColumn(label: Text('Nacimiento')),
        ],
        rows: _clientes.map((cliente) {
          return DataRow(
            cells: [
              DataCell(Text(cliente.id?.toString() ?? '-')),
              DataCell(Text('${cliente.nombres} ${cliente.apellidos}')),
              DataCell(Text(cliente.correo)),
              DataCell(Text(cliente.fechaNacimiento)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAbogadosTable() {
    if (_abogados.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('No hay abogados registrados aún.'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Correo')),
          DataColumn(label: Text('Especialidad')),
          DataColumn(label: Text('Verificado')),
          DataColumn(label: Text('Documentos')),
          DataColumn(label: Text('Acción')),
        ],
        rows: _abogados.map((abogado) {
          return DataRow(
            cells: [
              DataCell(Text(abogado.id?.toString() ?? '-')),
              DataCell(Text('${abogado.nombres} ${abogado.apellidos}')),
              DataCell(Text(abogado.correo)),
              DataCell(Text(abogado.especialidad ?? '-')),
              DataCell(Text(abogado.verificadoLabel)),
              DataCell(Text(abogado.documentosResumen)),
              DataCell(
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _toggleVerification(abogado),
                  child: Text(
                    abogado.verificado ? 'Quitar verificación' : 'Verificar',
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Administrador')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppTheme.primaryColor),
              child: Text(
                'Administrador',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Text(
                  'Clientes registrados',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildClientesTable(),
                const SizedBox(height: 24),
                const Text(
                  'Abogados registrados',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildAbogadosTable(),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
