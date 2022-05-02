import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:optica/model/user.dart';

enum Avisos { lents, estoig, solucio, revisio, personalitzat }

class Alerta {
  late String id, nombre;
  late DateTime tiempo;
  late int tipo;

  Alerta(this.nombre, this.tiempo, this.tipo) : id = "";

  Alerta.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    id = docSnap.id;
    final data = docSnap.data()!;
    tipo = data['tipo'];
    nombre = tipo == Avisos.personalitzat.index ? data['nombre'] : "";
    tiempo = (data['tiempo'] as Timestamp).toDate();
  }

  Map<String, dynamic> data() => {
        'nombre': nombre,
        'tiempo': Timestamp.fromDate(tiempo),
        'tipo': tipo,
      };

  void delete() {
    getUserRef().collection("avisos").doc(id).delete();
  }

  Future<void> save() async {
    final alertsRef = getUserRef().collection("avisos");
    if (id.isEmpty) {
      final doc = await alertsRef.add(data());
      id = doc.id;
    } else {
      await alertsRef.doc(id).update(data());
    }
  }
}

Stream<List<Alerta>> getUserAlerts() async* {
  final stream =
      getUserRef().collection("avisos").orderBy('tiempo').snapshots();
  await for (final docList in stream) {
    yield docList.docs.map((doc) => Alerta.fromDocumentSnapshot(doc)).toList();
  }
}

/*

db
                                              .collection("usuarios")
                                              .doc(FirebaseAuth.instance.currentUser?.email.toString())
                                              .collection("avisos")
                                              .add({
                                            'tiempo': DateTime(
                                                _date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute),
                                            'tipo': Avisos.personalitzat.index,
                                            'nombre': person.text,
                                          });
                                          */