import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../../controllers/auth_controller.dart';
import '../../models/abogado_model.dart';
import '../theme/app_theme.dart';

class RegisterAbogadoScreen extends StatefulWidget {
  const RegisterAbogadoScreen({super.key});

  @override
  State<RegisterAbogadoScreen> createState() => _RegisterAbogadoScreenState();
}

class _RegisterAbogadoScreenState extends State<RegisterAbogadoScreen> {
  int _currentStep = 0;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  // Paso 1: Personales
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  // Paso 2: Profesional
  String? _fotoPerfil;
  String? _especialidad;
  final List<String> _especialidades = ['Derecho Civil', 'Derecho Laboral', 'Derecho Penal', 'Derecho Comercial', 'Derecho Administrativo', 'Derecho de Familia'];
  final _aniosCtrl = TextEditingController();
  final _tarifaCtrl = TextEditingController();
  final _sobreTiCtrl = TextEditingController();

  // Paso 3: Documentos
  String? _docCedula;
  String? _docTarjeta;
  String? _docSirna;
  String? _docDiploma;
  String? _docAntecedentes;

  final _authController = AuthController();
  bool _isLoading = false;

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(data: AppTheme.lightTheme, child: child!),
    );
    if (picked != null) {
      setState(() => _fechaCtrl.text = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _fotoPerfil = image.path);
    }
  }

  Future<void> _pickDocument(int docIndex) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        switch (docIndex) {
          case 1: _docCedula = result.files.single.path; break;
          case 2: _docTarjeta = result.files.single.path; break;
          case 3: _docSirna = result.files.single.path; break;
          case 4: _docDiploma = result.files.single.path; break;
          case 5: _docAntecedentes = result.files.single.path; break;
        }
      });
    }
  }

  void _registrar() async {
    if (_docCedula == null || _docTarjeta == null || _docSirna == null || _docAntecedentes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sube todos los documentos obligatorios')));
      return;
    }

    setState(() => _isLoading = true);

    final abogado = Abogado(
      nombres: _nombresCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      fechaNacimiento: _fechaCtrl.text.trim(),
      correo: _correoCtrl.text.trim(),
      contrasena: _passCtrl.text,
      fotoPerfil: _fotoPerfil,
      especialidad: _especialidad,
      anosExperiencia: int.tryParse(_aniosCtrl.text) ?? 0,
      tarifa: _tarifaCtrl.text,
      sobreTi: _sobreTiCtrl.text,
      docCedula: _docCedula,
      docTarjetaProfesional: _docTarjeta,
      docSirna: _docSirna,
      docDiploma: _docDiploma,
      docAntecedentes: _docAntecedentes,
    );

    final success = await _authController.registerAbogado(abogado);
    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Registro exitoso'),
          content: const Text('Tu cuenta está en revisión. Te notificaremos cuando sea aprobada.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Aceptar'),
            )
          ],
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: El correo podría estar registrado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Abogado')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_formKey1.currentState!.validate() && _passCtrl.text == _confirmPassCtrl.text) {
              setState(() => _currentStep += 1);
            } else if (_passCtrl.text != _confirmPassCtrl.text) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
            }
          } else if (_currentStep == 1) {
            if (_formKey2.currentState!.validate() && _especialidad != null) {
              setState(() => _currentStep += 1);
            } else if (_especialidad == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una especialidad')));
            }
          } else {
            _registrar();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: _currentStep == 2 ? 'Finalizar' : 'Continuar',
                    isLoading: _isLoading,
                    onPressed: details.onStepContinue!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Volver',
                    isOutlined: true,
                    onPressed: details.onStepCancel!,
                  ),
                )
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Datos Personales'),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formKey1,
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
                  CustomTextField(hintText: 'Correo', controller: _correoCtrl, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  CustomTextField(hintText: 'Contraseña', controller: _passCtrl, isPassword: true),
                  const SizedBox(height: 16),
                  CustomTextField(hintText: 'Confirmar Contraseña', controller: _confirmPassCtrl, isPassword: true),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Información Profesional'),
            isActive: _currentStep >= 1,
            content: Form(
              key: _formKey2,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _fotoPerfil != null ? null : null, // Not assigning File() for cross-platform ease here, just path logic
                      child: _fotoPerfil == null ? const Icon(Icons.add_a_photo, size: 40) : const Icon(Icons.check, color: Colors.green, size: 40),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Especialidad'
                    ),
                    initialValue: _especialidad,
                    items: _especialidades.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _especialidad = val),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(hintText: 'Años de experiencia', controller: _aniosCtrl, keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  CustomTextField(hintText: 'Tarifa (Ej: \$150.000 COP/h)', controller: _tarifaCtrl),
                  const SizedBox(height: 16),
                  CustomTextField(hintText: 'Sobre ti (Max 300 caract.)', controller: _sobreTiCtrl, maxLines: 4),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Documentación'),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                _buildDocItem('Cédula de ciudadanía', _docCedula, () => _pickDocument(1), isRequired: true),
                _buildDocItem('Tarjeta profesional', _docTarjeta, () => _pickDocument(2), isRequired: true),
                _buildDocItem('Certificado SIRNA', _docSirna, () => _pickDocument(3), isRequired: true),
                _buildDocItem('Diploma pregrado (recomendado)', _docDiploma, () => _pickDocument(4)),
                _buildDocItem('Antecedentes Disciplinarios', _docAntecedentes, () => _pickDocument(5), isRequired: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocItem(String title, String? path, VoidCallback onTap, {bool isRequired = false}) {
    return ListTile(
      title: Text(title + (isRequired ? ' *' : '')),
      subtitle: Text(path != null ? 'Documento adjuntado' : 'Sin archivo', style: TextStyle(color: path != null ? Colors.green : Colors.grey)),
      trailing: IconButton(
        icon: const Icon(Icons.upload_file),
        onPressed: onTap,
      ),
    );
  }
}
