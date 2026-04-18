import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../../controllers/auth_controller.dart';
import '../../models/cliente_model.dart';
import '../theme/app_theme.dart';

class RegisterClienteScreen extends StatefulWidget {
  const RegisterClienteScreen({super.key});

  @override
  State<RegisterClienteScreen> createState() => _RegisterClienteScreenState();
}

class _RegisterClienteScreenState extends State<RegisterClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  final _authController = AuthController();
  bool _isLoading = false;

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme,
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _fechaCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text != _confirmPassCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
      return;
    }
    
    setState(() => _isLoading = true);
    
    final cliente = Cliente(
      nombres: _nombresCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      fechaNacimiento: _fechaCtrl.text.trim(),
      correo: _correoCtrl.text.trim(),
      contrasena: _passCtrl.text,
    );

    final success = await _authController.registerCliente(cliente);
    
    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro exitoso')));
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: El correo ya podría estar registrado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Cliente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(hintText: 'Nombres', controller: _nombresCtrl),
              const SizedBox(height: 16),
              CustomTextField(hintText: 'Apellidos', controller: _apellidosCtrl),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Fecha de Nacimiento', 
                controller: _fechaCtrl,
                readOnly: true,
                onTap: _selectDate,
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              const SizedBox(height: 16),
              CustomTextField(hintText: 'Correo electrónico', controller: _correoCtrl, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              CustomTextField(hintText: 'Contraseña', controller: _passCtrl, isPassword: true),
              const SizedBox(height: 16),
              CustomTextField(hintText: 'Confirmar Contraseña', controller: _confirmPassCtrl, isPassword: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Registrarme',
                  isLoading: _isLoading,
                  onPressed: _registrar,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
