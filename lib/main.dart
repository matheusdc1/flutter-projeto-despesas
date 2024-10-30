import 'package:controle_despesas/app/app_widget.dart';
import 'package:controle_despesas/app/core/pages/splash_screen.dart';
import 'package:controle_despesas/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SplashScreen());
  diSetup();
  await Future.wait<void>([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    Future.delayed(const Duration(milliseconds: 3750))
  ]);
  runApp(const AppWidget());
}
