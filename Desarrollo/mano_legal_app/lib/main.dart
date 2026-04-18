import 'package:flutter/material.dart';
import 'views/theme/app_theme.dart';
import 'views/auth/inicio_app_screen.dart';

void main() {
  runApp(const ManoLegalApp());
}

class ManoLegalApp extends StatelessWidget {
  const ManoLegalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManoLegal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const InicioAppScreen(),
    );
  }
}
