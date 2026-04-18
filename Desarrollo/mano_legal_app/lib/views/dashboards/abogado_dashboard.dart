import 'package:flutter/material.dart';
import '../../models/abogado_model.dart';
import '../theme/app_theme.dart';

class AbogadoDashboard extends StatelessWidget {
  final Abogado abogado;
  const AbogadoDashboard({super.key, required this.abogado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Abogado'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.primaryColor),
              accountName: Text('${abogado.nombres} ${abogado.apellidos}'),
              accountEmail: Text(abogado.correo),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: AppTheme.accentColor,
                child: Icon(Icons.gavel, color: Colors.white, size: 30),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Solicitudes de Casos'),
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
        child: Text('Bienvenido Abogado: ${abogado.nombres}\nEstado: ${abogado.estadoVerificado}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
