import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/configuration_1.dart';
import 'package:intl/intl.dart';
import 'package:optica/principalApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app.dart';

class Configuration_2 extends StatefulWidget {
  const Configuration_2({Key key}) : super(key: key);

  @override
  State<Configuration_2> createState() => _Configuration_2State();
}

final controller1_1 = TextEditingController();
final controller1_2 = TextEditingController();
final controller1_3 = TextEditingController();
final controller1_4 = TextEditingController();
final controller2_1 = TextEditingController();
final controller2_2 = TextEditingController();
final controller2_3 = TextEditingController();
final controller2_4 = TextEditingController();

List<TextEditingController> controllers = [
  controller1_1,
  controller1_2,
  controller1_3,
  controller1_4,
  controller2_1,
  controller2_2,
  controller2_3,
  controller2_4
];

class _Configuration_2State extends State<Configuration_2> {
  DateTime _dateTime;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              //Total flex = 12
              Expanded(
                child: Container(),
              ),
              const Expanded(
                child: BigText(text: "Configuració"),
              ),
              Expanded(
                flex: 7,
                child: Container(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LentInfo(numColumn: 1),
                        SizedBox(width: 40),
                        _LentInfo(numColumn: 2),
                      ],
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      child: Text(_dateTime == null
                          ? "Tria una data"
                          : DateFormat("yyyy-MM-dd").format(_dateTime)),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 40),
                          shape: const StadiumBorder(),
                          primary: Colors.grey,
                          onPrimary: Colors.black),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2030))
                            .then((date) {
                          setState(() {
                            _dateTime = date;
                          });
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      child: Text("Guardar", style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          shape: const StadiumBorder(),
                          primary: Colors.grey,
                          onPrimary: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                )),
              ),
              Expanded(
                flex: 0,
                child: TextButton(
                  child:
                      const Text("Historial", style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 40),
                      shape: const StadiumBorder(),
                      primary: Colors.grey,
                      onPrimary: Colors.black),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Historial'),
                            content: StreamBuilder(
                              stream: db
                                  .collection("usuarios")
                                  .doc(FirebaseAuth.instance.currentUser.email
                                      .toString())
                                  .collection("historial")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasData) {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    child: ListView(
                                        children: snapshot.data.docs.map((e) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(e['tipo'].toString()),
                                        ),
                                      );
                                    }).toList()),
                                  );
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
                ),
              ),
              Expanded(
                flex: 0,
                child: TextButton(
                  child:
                      const Text("Continuar", style: TextStyle(fontSize: 10)),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      shape: const StadiumBorder(),
                      primary: Colors.grey,
                      onPrimary: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Principal()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LentInfo extends StatelessWidget {
  final numColumn;
  const _LentInfo({Key key, this.numColumn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var add = numColumn + 4;
    return Column(
      children: [
        Container(
          child: const Icon(Icons.remove_red_eye_outlined, size: 80),
        ),
        SizedBox(
          width: 120,
          height: 65,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controllers.elementAt(1 + add),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "dubte",
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          height: 65,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controllers.elementAt(1 + add),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "dubte",
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          height: 65,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controllers.elementAt(1 + add),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "dubte",
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          height: 65,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controllers.elementAt(1 + add),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "dubte",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
