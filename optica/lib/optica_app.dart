import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/principal.dart';
import 'package:optica/screens/first_connection.dart';

class OpticaApp extends StatelessWidget {
  const OpticaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
              return const FirstConnection();
            } else {
              return const Principal();
            }
        }
      },
    );
  }
}
