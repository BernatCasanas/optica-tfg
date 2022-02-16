import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'AuthGate.dart';
import 'app.dart';

void main() async {
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const AuthGate(
      app: App(),
    ),
  );
}
