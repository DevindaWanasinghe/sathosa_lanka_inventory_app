import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterManagerScreen extends StatefulWidget {
  const RegisterManagerScreen({super.key});

  @override
  State<RegisterManagerScreen> createState() => _RegisterManagerScreenState();
}

class _RegisterManagerScreenState extends State<RegisterManagerScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController branchCtrl = TextEditingController();
  final AuthService _authService = AuthService();

  void _registerManager() async {
    final user = await _authService.registerWithEmail(
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      role: "manager",
      branchId: branchCtrl.text.trim(),
    );

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Manager account created")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to register manager")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Manager")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Manager Email'),
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: branchCtrl,
              decoration: const InputDecoration(labelText: 'Branch ID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerManager,
              child: const Text("Create Manager Account"),
            ),
          ],
        ),
      ),
    );
  }
}
