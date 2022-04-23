// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optica/widgets/big_text.dart';
import 'package:optica/widgets/small_text.dart';

import 'configuration_2.dart';

enum AVISOS { LENTS, ESTOIG, SOLUCIO, REVISIO, PERSONALITZAT }

final controllerLents = TextEditingController();
final controllerDuracio = TextEditingController();

bool error = false;

class Configuration1 extends StatefulWidget {
  const Configuration1({Key? key}) : super(key: key);

  @override
  State<Configuration1> createState() => _Configuration1State();
}

class _Configuration1State extends State<Configuration1> {
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(children: [
            //Total flex = 12
            Expanded(
              flex: 1,
              child: Container(),
            ),
            const Expanded(
              child: BigText(text: "Configuració"),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SmallText(text: "Lents"),
                      MainInput(text: "Vida útil", controller: controllerLents)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SmallText(text: "Duració Lents"),
                      MainInput(text: "Temps diari", controller: controllerDuracio)
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SmallText(text: "Revisió"),
                TextButton(
                  child: Text(_dateTime == null ? "Tria una data" : DateFormat("yyyy-MM-dd").format(_dateTime!)),
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
                )
              ]),
            ),
            Expanded(
              flex: 0,
              child: Column(
                children: [
                  TextButton(
                    child: const Text("Continuar", style: TextStyle(fontSize: 10)),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        shape: const StadiumBorder(),
                        primary: Colors.grey,
                        onPrimary: Colors.black),
                    onPressed: () {
                      setState(() {
                        if (controllerDuracio.text == "" || controllerLents.text == "" || _dateTime == null) {
                          error = true;
                          return;
                        }
                        error = false;
                      });
                      if (error) {
                        return;
                      }

                      final db = FirebaseFirestore.instance
                          .collection("usuarios")
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .collection("avisos");

                      var today = DateTime.now();

                      db.add({
                        'tipo': AVISOS.ESTOIG.index,
                        'tiempo': today.add(const Duration(days: 90)),
                      });
                      db.add({
                        'tipo': AVISOS.LENTS.index,
                        'tiempo': today.add(Duration(days: int.parse(controllerLents.text))),
                      });
                      db.add({
                        'tipo': AVISOS.SOLUCIO.index,
                        'tiempo': today.add(const Duration(days: 60)),
                      });
                      db.add({
                        'tipo': AVISOS.REVISIO.index,
                        'tiempo': today.add(_dateTime!.difference(DateTime.now())),
                      });

                      FirebaseFirestore.instance
                          .collection("usuarios")
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .update({'duración_diaria': int.parse(controllerDuracio.text)});

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Configuration2(fromEditScreen: false)),
                      );
                    },
                  ),
                  const SizedBox(height: 2),
                  error == true ? const Text("Falta omplir dades", style: TextStyle(color: Colors.red)) : Container(),
                ],
              ),
            ),
            Expanded(flex: 1, child: Container())
          ]),
        ),
      ),
    );
  }
}

class MainInput extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  const MainInput({
    Key? key,
    required this.text,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 65,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: text,
          ),
        ),
      ),
    );
  }
}
