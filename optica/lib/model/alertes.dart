import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:optica/model/user.dart';

enum Avisos { lents, estoig, solucio, revisio, personalitzat }

class Alerta {
  late String id, nombre;
  late DateTime tiempo;
  late int tipo;

  Alerta.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    id = docSnap.id;
    final data = docSnap.data()!;
    nombre = data['nombre'];
    tiempo = (data['tiempo'] as Timestamp).toDate();
    tipo = data['tipo'];
  }

  void delete() {
    getUserRef().collection("avisos").doc(id).delete();
  }
}

Stream<List<Alerta>> getUserAlerts() async* {
  final stream = getUserRef().collection("avisos").orderBy('tiempo').snapshots();
  await for (final docList in stream) {
    yield docList.docs.map((doc) => Alerta.fromDocumentSnapshot(doc)).toList();
  }
}
