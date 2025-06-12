import 'package:flutter/material.dart';

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manager Home')),
      body: const Center(child: Text('Welcome, Manager')),
    );
  }
}
