import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/configuration_1.dart';
import 'package:optica/principal_app.dart';

final TextEditingController controllerNombre = TextEditingController();
final TextEditingController controllerCodigo = TextEditingController();

bool error = false;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("usuarios")
          .doc(FirebaseAuth.instance.currentUser?.email)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var data;
            var value;
            try {
              data = snapshot.data!.data();
              value = data!['codigo'];
              return const Principal();
            } catch (e) {
              FirebaseFirestore.instance
                  .collection("usuarios")
                  .doc(FirebaseAuth.instance.currentUser?.email)
                  .set({
                'codigo': "",
                'llevaLentillas': false,
                'nivel_recompensa': 1,
                'nombre': "",
              });
              return const _FirstConnection();
            }
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _FirstConnection extends StatefulWidget {
  const _FirstConnection({
    Key? key,
  }) : super(key: key);

  @override
  State<_FirstConnection> createState() => _FirstConnectionState();
}

class _FirstConnectionState extends State<_FirstConnection> {
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
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      const _Button(name: "Accedeix"),
                      error == true
                          ? const Text("Falta omplir dades",
                              style: TextStyle(color: Colors.red))
                          : Container(),
                    ],
                  ),
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

class _Button extends StatefulWidget {
  final String name;
  const _Button({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (controllerCodigo.text == "" || controllerNombre.text == "") {
            error = true;
            return;
          }
          error = false;
        });
        if (error) {
          return;
        }

        FirebaseFirestore.instance
            .collection("usuarios")
            .doc(FirebaseAuth.instance.currentUser?.email.toString())
            .update({
          'codigo': controllerCodigo.text,
          'nombre': controllerNombre.text
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Configuration1()),
        );
      },
      child: Text(widget.name),
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
    final controller1 = name == "Nom" ? controllerNombre : controllerCodigo;

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
