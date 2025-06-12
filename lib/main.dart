import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

//screens
import 'views/auth/login_screen.dart';
import 'views/admin/admin_home_screen.dart';
import 'views/manager/manager_home_screen.dart';
import 'views/staff/staff_home_screen.dart';

//Firestore role-fetching service
import 'services/firestore_service.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  logger.i("✅ Firebase initialized!");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(), // ✅ Handles login status check
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<String?>(
            future: FirestoreService().getUserRole(snapshot.data!.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final role = roleSnapshot.data?.toLowerCase();

              if (role == 'admin') {
                return const AdminHomeScreen();
              } else if (role == 'manager') {
                return const ManagerHomeScreen();
              } else if (role == 'staff' || role == 'employee') {
                return const StaffHomeScreen();
              } else {
                // Unknown role or not set
                return const Scaffold(
                  body: Center(child: Text("❗ Unknown role. Contact Admin.")),
                );
              }
            },
          );
        }

        // Not logged in
        return const LoginScreen();
      },
    );
  }
}
