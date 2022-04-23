import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/model/alertes.dart';
import 'package:optica/utils/dates.dart';

class Alertes extends StatefulWidget {
  const Alertes({Key? key}) : super(key: key);

  @override
  State<Alertes> createState() => _AlertesState();
}

class _AlertesState extends State<Alertes> {
  TextEditingController person = TextEditingController();

  DateTime? _date = DateTime.now();
  TimeOfDay? _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: StreamBuilder(
              stream: getUserAlerts(),
              builder: (BuildContext context, AsyncSnapshot<List<Alerta>> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: snapshot.data!.map<Widget>((alerta) {
                            bool justName = false;
                            String title = "";
                            if (alerta.tipo == 3) {
                              justName = true;
                              title = "Revisió";
                            }
                            if (alerta.tipo == 4) {
                              justName = true;
                              title = alerta.nombre;
                            }
                            return Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  width: 350,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.all(Radius.circular(20))),
                                  child: ListTile(
                                    trailing: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection("usuarios")
                                                .doc(FirebaseAuth.instance.currentUser?.email)
                                                .collection("avisos")
                                                .doc(alerta.id)
                                                .delete();
                                          });
                                        },
                                        child: const Icon(Icons.close, color: Colors.black)),
                                    leading: alerta.tipo == 0
                                        ? const Icon(Icons.remove_red_eye)
                                        : alerta.tipo == 1
                                            ? const Icon(Icons.camera_sharp)
                                            : alerta.tipo == 2
                                                ? const Icon(Icons.water)
                                                : alerta.tipo == 3
                                                    ? const Icon(Icons.record_voice_over_sharp)
                                                    : const Icon(Icons.star),
                                    title: !justName
                                        ? Text("Canviar ${Avisos.values.elementAt(alerta.tipo).name.toLowerCase()}")
                                        : Text(title),
                                    subtitle: Text(tempsRestant(alerta.tiempo)),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
        Expanded(
          flex: 0,
          child: TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alterta Personalitzada'),
                      content: StreamBuilder(
                        stream: db
                            .collection("usuarios")
                            .doc(FirebaseAuth.instance.currentUser!.email.toString())
                            .collection("avisos")
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            return SizedBox(
                                height: 200,
                                width: 250,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                        TextButton(
                                            onPressed: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now().add(const Duration(seconds: 1)),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                              ).then((value) {
                                                setState(() {
                                                  _date = value;
                                                });
                                              });
                                            },
                                            child: Text("${_date!.day}/${_date!.month}/${_date!.year}")),
                                        TextButton(
                                            onPressed: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime:
                                                    TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                                              ).then((value) {
                                                _time = value;
                                              });
                                            },
                                            child: Text("${_time!.hour}:${_time!.minute}")),
                                      ]),
                                      TextField(
                                        controller: person,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 14),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Nom alerta",
                                        ),
                                      ),
                                      TextButton(
                                        child: const Text("Guardar", style: TextStyle(fontSize: 10)),
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(100, 40),
                                            shape: const StadiumBorder(),
                                            primary: Colors.grey,
                                            onPrimary: Colors.black),
                                        onPressed: () {
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
                                        },
                                      ),
                                    ],
                                  ),
                                ));
                          } else {
                            return Container();
                          }
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Tanca'),
                        ),
                      ],
                    );
                  });
            },
            child: const Text("Alerta Personalitzada"),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 40),
                shape: const StadiumBorder(),
                primary: Colors.grey[400],
                onPrimary: Colors.black),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
