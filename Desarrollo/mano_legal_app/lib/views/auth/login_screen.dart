import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../../controllers/auth_controller.dart';
import 'pre_register_screen.dart';
import '../dashboards/cliente_dashboard.dart';
import '../dashboards/abogado_dashboard.dart';
import '../dashboards/admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _authController = AuthController();
  bool _isLoading = false;

  void _login() async {
    if (_correoCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Llena todos los campos')));
      return;
    }
    setState(() => _isLoading = true);

    final result = await _authController.login(
      _correoCtrl.text.trim(),
      _passCtrl.text,
    );

    setState(() => _isLoading = false);

    if (result != null) {
      if (!mounted) return;
      if (result['tipo'] == 'cliente') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ClienteDashboard(cliente: result['datos']),
          ),
        );
      } else if (result['tipo'] == 'abogado') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AbogadoDashboard(abogado: result['datos']),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Bienvenido!!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Encuentra la asesoría legal que necesitas de forma fácil y segura.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 40),
            const Icon(Icons.rocket_launch, size: 80, color: Colors.amber),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Inicia sesión',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'ingresa tu correo electrónico',
              controller: _correoCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'ingresa tu contraseña',
              controller: _passCtrl,
              isPassword: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Iniciar sesión',
                isLoading: _isLoading,
                onPressed: _login,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿No tienes una cuenta? '),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PreRegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
