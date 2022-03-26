import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/configuration_1.dart';
import 'package:optica/principal_app.dart';

final TextEditingController controller_nombre = TextEditingController();
final TextEditingController controller_codigo = TextEditingController();
final currentUser = FirebaseAuth.instance.currentUser;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ds = FirebaseFirestore.instance
        .collection("usuarios")
        .doc(currentUser?.email.toString())
        .get();
    return ds.then((value) => value['codigo']) == ""
        ? _FirstConnection()
        : Principal();
  }
}

class _FirstConnection extends StatelessWidget {
  const _FirstConnection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                const Expanded(
                  flex: 2,
                  child: BigText(text: "NomApp"),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      _InputBox(name: "Nom"),
                      SizedBox(height: 12),
                      _InputBox(name: "Codi Deontologic"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                const Expanded(
                  flex: 0,
                  child: _Button(name: "Accedeix"),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
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

class _Button extends StatelessWidget {
  final String name;
  const _Button({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FirebaseFirestore.instance
            .collection("usuarios")
            .doc(currentUser?.email.toString())
            .update({
          'codigo': controller_codigo.text,
          'nombre': controller_nombre.text
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Configuration1()),
        );
      },
      child: Text(name),
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50),
          shape: const StadiumBorder(),
          primary: Colors.grey),
    );
  }
}

class _InputBox extends StatelessWidget {
  final String name;
  const _InputBox({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller1 = name == "Nom" ? controller_nombre : controller_codigo;

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
              controller: controller1,
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
