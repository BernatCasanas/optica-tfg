import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:optica/widgets/ofertes.dart';

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
    final userRef = getUserRef();
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

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

String getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser!;
  if (user.email == null) {
    throw "He trobat un usuari sense correu electrònic!";
  }
  return user.email!;
}

DocumentReference<Map<String, dynamic>> getUserRef() {
  String userId = getCurrentUserId();
  return FirebaseFirestore.instance.collection("usuarios").doc(userId);
}

Future<Usuari?> maybeGetUser() async {
  final userRef = getUserRef();
  final doc = await userRef.get();
  if (!doc.exists) {
    return null;
  } else {
    return Usuari.fromFirestore(doc.data()!);
  }
}

Future<int> maybeGetPoints() async {
  int points;

  final userRef = getUserRef();
  final doc = await userRef.get();
  if (!doc.exists) {
    points = 0;
  } else {
    points = doc['puntos'];
  }

  return points;
}

Future<int> maybeGetLevel() async {
  int level;

  final userRef = getUserRef();
  final doc = await userRef.get();
  if (!doc.exists) {
    level = 0;
  } else {
    level = doc['nivel_recompensa'];
  }

  return level;
}

void addPoints(int points) async {
  final userRef = getUserRef();
  final doc = await userRef.get();
  if (!doc.exists) {
    return;
  } else {
    int currentPoints = await maybeGetPoints();
    int level = await maybeGetLevel();
    if (currentPoints + points >= getMaxPoints(level)) {
      if (level == 5) return;

      userRef.update({
        'puntos': currentPoints + points - getMaxPoints(level),
        'nivel_recompensa': ++level
      });
    } else {
      userRef.update({
        'puntos': currentPoints + points,
      });
    }
  }
}

Stream<Usuari> currentUserStream() =>
    getUserRef().snapshots().map((doc) => Usuari.fromFirestore(doc.data()!));

Future<void> initializeUserData() async {
  return getUserRef().set({
    'codigo': "",
    'llevaLentillas': false,
    'nivel_recompensa': 1,
    'nombre': "",
  });
}
