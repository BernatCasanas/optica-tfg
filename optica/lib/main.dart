import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:optica/firebase_options.dart';
import 'package:optica/screens/principal.dart';
import 'package:optica/screens/configura0_inici.dart';
import 'package:optica/widgets/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
  runApp(
    const AuthGate(
      app: OpticaApp(),
    ),
  );
}

class OpticaApp extends StatelessWidget {
  const OpticaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection("usuarios").doc(FirebaseAuth.instance.currentUser?.email).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return ErrorWidget("No esperaba un ConnectionState.active al FutureBuilder de l'usuari");
            case ConnectionState.none:
              return ErrorWidget("No esperaba un ConnectionState.none al FutureBuilder de l'usuari");
            case ConnectionState.done:
              final data = snapshot.data!;
              if (!data.exists) {
                FirebaseFirestore.instance.collection("usuarios").doc(FirebaseAuth.instance.currentUser?.email).set({
                  'codigo': "",
                  'llevaLentillas': false,
                  'nivel_recompensa': 1,
                  'nombre': "",
                });
                return const Configura0Inici();
              } else {
                return const Principal();
              }
          }
        },
      ),
    );
  }
}
