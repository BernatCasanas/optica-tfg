import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/configuration_1.dart';
import 'package:optica/widgets/big_text.dart';

class FirstConnection extends StatefulWidget {
  const FirstConnection({Key? key}) : super(key: key);

  @override
  State<FirstConnection> createState() => _FirstConnectionState();
}

class _FirstConnectionState extends State<FirstConnection> {
  TextEditingController controllerCodigo = TextEditingController();
  TextEditingController controllerNombre = TextEditingController();
  bool buttonEnabled = false;

  void textChanged() {
    setState(() {
      buttonEnabled = (controllerCodigo.text.isNotEmpty && controllerNombre.text.isNotEmpty);
    });
  }

  @override
  initState() {
    super.initState();
    controllerCodigo.addListener(textChanged);
    controllerNombre.addListener(textChanged);
  }

  @override
  void dispose() {
    controllerCodigo.dispose();
    controllerNombre.dispose();
    super.dispose();
  }

  void saveDataAndNextStep() {
    final userId = FirebaseAuth.instance.currentUser?.email.toString();
    FirebaseFirestore.instance.collection("usuarios").doc(userId).update({
      'codigo': controllerCodigo.text,
      'nombre': controllerNombre.text,
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Configuration1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          const Expanded(
            flex: 2,
            child: BigText(text: "NomApp"),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _InputBox(name: "Nom", controller: controllerNombre),
                const SizedBox(height: 12),
                _InputBox(name: "Codi Deontologic", controller: controllerCodigo),
              ],
            ),
          ),
          const Spacer(),
          Column(
            children: [
              ElevatedButton(
                onPressed: buttonEnabled ? saveDataAndNextStep : null,
                child: const Text("Accedeix"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  shape: const StadiumBorder(),
                  primary: Colors.grey,
                ),
              ),
              if (error)
                const Text(
                  "Falta omplir dades",
                  style: TextStyle(color: Colors.red),
                )
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    Key? key,
    required this.name,
    required this.controller,
  }) : super(key: key);

  final String name;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          SizedBox(
            height: 35,
            child: TextField(
              controller: controller,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
