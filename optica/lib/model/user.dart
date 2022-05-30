import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:optica/widgets/ofertes.dart';

enum Historial { graduacio, posar, treure, estoig, blister, solucio }

class Usuari {
  String codi, nomComplet;
  int duracioDiaria;
  bool portaLentilles;
  int nivellRecompensa;
  int puntos;
  int racha;
  DateTime tiempoCuentaCreada;
  DateTime ultimo_cambio;

  Usuari.fromFirestore(Map<String, dynamic> data)
      : codi = data['codigo'],
        nomComplet = data['nombre'],
        duracioDiaria = data['duración_diaria'],
        portaLentilles = data['llevaLentillas'],
        nivellRecompensa = data['nivel_recompensa'] ?? 1,
        puntos = data['puntos'] ?? 0,
        racha = data['racha'] ?? 0,
        tiempoCuentaCreada = data['tiempoCuentaCreada'].toDate(),
        ultimo_cambio = data['ultimo_cambio'].toDate();

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

  void userActionUpdate() =>
      getUserRef().update({'ultimo_cambio': DateTime.now()});
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
  final usuari = await maybeGetUser();
  if (usuari == null) {
    throw "Error Intern: no he pogut obtenir l'usuari a 'addPoints'";
  }
  final level = usuari.nivellRecompensa;
  final maxPoints = getLevel(level).maxPoints;
  if (usuari.puntos + points >= maxPoints) {
    if (level == 5) {
      return;
    }
    getUserRef().update({
      'puntos': FieldValue.increment(points - maxPoints),
      'nivel_recompensa': FieldValue.increment(1),
    });
  } else {
    getUserRef().update({
      'puntos': FieldValue.increment(points),
    });
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
    'puntos': 10,
    'racha': 1,
    'tiempoCuentaCreada': DateTime.now(),
    'ultimo_cambio': DateTime(2000, 1, 1),
  });
}
