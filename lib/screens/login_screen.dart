import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'vault_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _authFailed = false;

  Future<void> _authenticate() async {
    bool success = await _authService.authenticate();
    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VaultScreen()),
      );
    } else {
      setState(() => _authFailed = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _authFailed
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Authentication Failed'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _authenticate,
                    child: const Text('Try Again'),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
