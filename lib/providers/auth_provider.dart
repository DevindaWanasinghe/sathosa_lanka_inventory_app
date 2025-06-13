import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light;
});

// Add this new provider or modify your theme usage
final brightnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
});
