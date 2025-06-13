import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//screens
import 'views/auth/login_screen.dart';
import 'views/admin/admin_home_screen.dart';
import 'views/manager/manager_home_screen.dart';
import 'views/staff/staff_home_screen.dart';

// Services
import 'services/firestore_service.dart';

// Providers
import 'providers/auth_provider.dart';

final logger = Logger(
  // ignore: deprecated_member_use
  printer: PrettyPrinter(colors: true, printEmojis: true, printTime: true),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    logger.i("✅ Firebase initialized successfully");
  } catch (e) {
    logger.e("🔥 Firebase initialization failed", error: e);
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(brightnessProvider);
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: brightness,
      ),
      useMaterial3: true,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Role-Based Dashboard',
      theme: theme,
      darkTheme: theme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const AuthGate(),
      onGenerateRoute: (settings) {
        // Add named routes if needed
        return null;
      },
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: ${error.toString()}'))),
      data: (user) {
        if (user == null) return const LoginScreen();

        return FutureBuilder<String?>(
          future: FirestoreService().getUserRole(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Role Error: ${snapshot.error}')),
              );
            }

            final role = snapshot.data?.toLowerCase().trim();

            switch (role) {
              case 'admin':
                return const AdminHomeScreen();
              case 'manager':
                return const ManagerHomeScreen();
              case 'staff':
              case 'employee':
                return const StaffHomeScreen();
              default:
                FirebaseAuth.instance.signOut();
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Invalid role assignment'),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          ),
                          child: const Text('Return to Login'),
                        ),
                      ],
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}
