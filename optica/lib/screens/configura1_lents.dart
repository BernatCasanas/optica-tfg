// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optica/model/alertes.dart';
import 'package:optica/screens/configura2_graduacio.dart';
import 'package:optica/widgets/big_text.dart';
import 'package:optica/widgets/small_text.dart';

final controllerLents = TextEditingController();
final controllerLentsDuracio = TextEditingController();
final controllerEstiogDuracio = TextEditingController();
final controllerSolucioDuracio = TextEditingController();

bool error = false;

class Configura1Lents extends StatefulWidget {
  const Configura1Lents({Key? key}) : super(key: key);

  @override
  State<Configura1Lents> createState() => _Configura1LentsState();
}

class _Configura1LentsState extends State<Configura1Lents> {
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
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
            flex: 3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SmallText(text: "Lents"),
                        MainInput(
                            text: "Vida útil", controller: controllerLents)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SmallText(text: "Duració Lents"),
                        MainInput(
                            text: "Temps diari",
                            controller: controllerLentsDuracio)
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SmallText(text: "Duració Estoig"),
                        MainInput(
                            text: "Vida útil",
                            controller: controllerEstiogDuracio)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SmallText(text: "Duració Solució"),
                        MainInput(
                            text: "Vida útil",
                            controller: controllerSolucioDuracio)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SmallText(text: "Revisió"),
              TextButton(
                child: Text(_dateTime == null
                    ? "Tria una data"
                    : DateFormat("yyyy-MM-dd").format(_dateTime!)),
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
                  child:
                      const Text("Continuar", style: TextStyle(fontSize: 10)),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      shape: const StadiumBorder(),
                      primary: Colors.grey,
                      onPrimary: Colors.black),
                  onPressed: () {
                    setState(() {
                      if (controllerLentsDuracio.text == "" ||
                          controllerLents.text == "" ||
                          controllerSolucioDuracio.text == "" ||
                          controllerEstiogDuracio.text == "" ||
                          _dateTime == null) {
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
                      'tipo': Avisos.estoig.index,
                      'tiempo': today.add(const Duration(days: 90)),
                    });
                    db.add({
                      'tipo': Avisos.lents.index,
                      'tiempo': today
                          .add(Duration(days: int.parse(controllerLents.text))),
                    });
                    db.add({
                      'tipo': Avisos.solucio.index,
                      'tiempo': today.add(const Duration(days: 60)),
                    });
                    db.add({
                      'tipo': Avisos.revisio.index,
                      'tiempo':
                          today.add(_dateTime!.difference(DateTime.now())),
                    });

                    FirebaseFirestore.instance
                        .collection("usuarios")
                        .doc(FirebaseAuth.instance.currentUser?.email)
                        .update({
                      'duración_diaria': int.parse(controllerLentsDuracio.text)
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Configura2Graduacio(fromEditScreen: false)),
                    );
                  },
                ),
                const SizedBox(height: 2),
                error == true
                    ? const Text("Falta omplir dades",
                        style: TextStyle(color: Colors.red))
                    : Container(),
              ],
            ),
          ),
          Expanded(flex: 1, child: Container())
        ]),
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
