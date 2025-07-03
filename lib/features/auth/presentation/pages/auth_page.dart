import 'package:flutter/material.dart';

import '../pages/login_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: const LoginPage(),
    );
  }
}
