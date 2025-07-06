import 'package:flutter/widgets.dart';
import 'package:opsmate/features/auth/provider/auth_providers.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool _isLoading = false;
  final emailController = TextEditingController();
  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .sendPasswordResetEmail(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
