import 'package:flutter/material.dart';
import '../../models/cliente_model.dart';
import '../theme/app_theme.dart';

class ClienteDashboard extends StatelessWidget {
  final Cliente cliente;
  const ClienteDashboard({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Cliente'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.primaryColor),
              accountName: Text('${cliente.nombres} ${cliente.apellidos}'),
              accountEmail: Text(cliente.correo),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: AppTheme.accentColor,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Buscar Abogados'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Bienvenido Cliente: ${cliente.nombres}', style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
