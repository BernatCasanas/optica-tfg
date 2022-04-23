import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Historial { graduacio, posar, treure, estoig, blister, solucio }

class Usuari {
  String codi, nomComplet;
  int duracioDiaria;
  bool portaLentilles;
  int nivellRecompensa;

  Usuari.fromFirestore(Map<String, dynamic> data)
      : codi = data['codigo'],
        nomComplet = data['nombre'],
        duracioDiaria = data['duración_diaria'],
        portaLentilles = data['llevaLentillas'],
        nivellRecompensa = data['nivel_recompensa'];

  Future<void> toggleContactLenses() async {
    portaLentilles = !portaLentilles;
    final userRef = getCurrentUserRef();
    userRef.update({'llevaLentillas': portaLentilles});
    userRef.collection("historial").add({
      'tipo': portaLentilles ? Historial.posar.index : Historial.treure.index,
      'fecha': DateTime.now(),
    });
    if (portaLentilles) {
      userRef.collection("avisos").add({
        'nombre': "Treure les lents",
        'tipo': 4,
        'tiempo': DateTime.now().add(Duration(hours: duracioDiaria)),
      });
    }
  }
}

String getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser!;
  if (user.email == null) {
    throw "He trobat un usuari sense correu electrònic!";
  }
  return user.email!;
}

DocumentReference<Map<String, dynamic>> getCurrentUserRef() {
  String userId = getCurrentUserId();
  return FirebaseFirestore.instance.collection("usuarios").doc(userId);
}

Future<Usuari?> maybeGetCurrentUser() async {
  final userRef = getCurrentUserRef();
  final doc = await userRef.get();
  if (!doc.exists) {
    return null;
  } else {
    return Usuari.fromFirestore(doc.data()!);
  }
}

Stream<Usuari> currentUserStream() => getCurrentUserRef().snapshots().map((doc) => Usuari.fromFirestore(doc.data()!));

Future<void> initializeUserData() async {
  return getCurrentUserRef().set({
    'codigo': "",
    'llevaLentillas': false,
    'nivel_recompensa': 1,
    'nombre': "",
  });
}
