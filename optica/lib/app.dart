import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/configuration_1.dart';
import 'package:optica/principal_app.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection("usuarios").doc(FirebaseAuth.instance.currentUser?.email).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            return ErrorWidget("No esperaba un ConnectionState.active al FutureBuilder de l'usuari");
          case ConnectionState.none:
            return ErrorWidget("No esperaba un ConnectionState.none al FutureBuilder de l'usuari");
          case ConnectionState.done:
            final data = snapshot.data!;
            if (!data.exists) {
              FirebaseFirestore.instance.collection("usuarios").doc(FirebaseAuth.instance.currentUser?.email).set({
                'codigo': "",
                'llevaLentillas': false,
                'nivel_recompensa': 1,
                'nombre': "",
              });
              return const _FirstConnection();
            } else {
              return const Principal();
            }
        }
      },
    );
  }
}

class _FirstConnection extends StatefulWidget {
  const _FirstConnection({Key? key}) : super(key: key);

  @override
  State<_FirstConnection> createState() => _FirstConnectionState();
}

class _FirstConnectionState extends State<_FirstConnection> {
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
    return MaterialApp(
      home: Scaffold(
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
      ),
    );
  }
}

class BigText extends StatelessWidget {
  final String text;

  const BigText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }
}

class SmallText extends StatelessWidget {
  final String text;

  const SmallText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
