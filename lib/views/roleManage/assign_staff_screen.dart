import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterStaffScreen extends StatefulWidget {
  const RegisterStaffScreen({super.key});

  @override
  State<RegisterStaffScreen> createState() => _RegisterStaffScreenState();
}

class _RegisterStaffScreenState extends State<RegisterStaffScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController branchCtrl = TextEditingController();
  final AuthService _authService = AuthService();

  void _registerStaff() async {
    final user = await _authService.registerWithEmail(
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      role: "staff",
      branchId: branchCtrl.text.trim(),
    );

    if (user != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Staff account created")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to register staff")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Staff")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Staff Email'),
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
              onPressed: _registerStaff,
              child: const Text("Create Staff Account"),
            ),
          ],
        ),
      ),
    );
  }
}
