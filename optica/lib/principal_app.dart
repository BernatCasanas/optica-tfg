import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final pages = <Widget>[
  const Alertes(),
  const Progres(),
  const Ofertes(),
  const Editar(),
];

int indexPage = 0;

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          bottomNavigationBar: _NavigatorBar(notifyParent: Refresh),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                    color: Colors.grey[400],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        child: Text(
                          pages[indexPage].toString(),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                  flex: 3),
              Expanded(child: pages[indexPage], flex: 13)
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigatorBar extends StatelessWidget {
  final Function() notifyParent;
  const _NavigatorBar({Key? key, required this.notifyParent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        indexPage = 0;
                        notifyParent();
                      })),
              IconButton(
                  icon: const Icon(Icons.calendar_today_rounded),
                  onPressed: () {
                    indexPage = 1;
                    notifyParent();
                  }),
              IconButton(
                  icon: const Icon(Icons.shopping_bag),
                  onPressed: () {
                    indexPage = 2;
                    notifyParent();
                  }),
              Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        indexPage = 3;
                        notifyParent();
                      })),
            ],
          ),
        ));
  }
}

//Pantalles que després aniràn en diferents arxius

class Alertes extends StatelessWidget {
  const Alertes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: StreamBuilder(
              stream: db
                  .collection("usuarios")
                  .doc(FirebaseAuth.instance.currentUser!.email.toString())
                  .collection("avisos")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: snapshot.data!.docs.map<Widget>((e) {
                            return Column(
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  width: 350,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: ListTile(
                                    leading: const Icon(Icons.star),
                                    title:
                                        Text("Tipus ${e['tipo'].toString()}"),
                                    subtitle: Text(
                                        "Queden ${e['tiempo'].toString()} dies"),
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
                  return const CircularProgressIndicator();
                }
              }),
        ),
        Expanded(
          flex: 0,
          child: TextButton(
            onPressed: () {},
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

class Progres extends StatelessWidget {
  const Progres({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Search");
  }
}

class Ofertes extends StatelessWidget {
  const Ofertes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Search");
  }
}

class Editar extends StatelessWidget {
  const Editar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Search");
  }
}
