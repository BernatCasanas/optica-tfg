import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usuari {
  String codi;
  String nomComplet;
  int? duracioDiaria;
  bool portaLentilles;
  int nivellRecompensa;

  Usuari.fromFirestore(Map<String, dynamic> data)
      : codi = data['codigo'],
        nomComplet = data['nombre'],
        duracioDiaria = data['duración_diaria'],
        portaLentilles = data['llevaLentillas'],
        nivellRecompensa = data['nivel_recompensa'];
}

String getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser!;
  if (user.email == null) {
    throw "He trobat un usuari sense correu electrònic!";
  }
  return user.email!;
}

Future<Usuari?> getCurrentUser() async {
  String userId = getCurrentUserId();
  final userRef = FirebaseFirestore.instance.collection("usuarios").doc(userId);
  final doc = await userRef.get();
  if (!doc.exists) {
    return null;
  } else {
    return Usuari.fromFirestore(doc.data()!);
  }
}

Future<void> initializeUserData() async {
  final userId = getCurrentUserId();
  await FirebaseFirestore.instance.collection("usuarios").doc(userId).set({
    'codigo': "",
    'llevaLentillas': false,
    'nivel_recompensa': 1,
    'nombre': "",
  });
}
