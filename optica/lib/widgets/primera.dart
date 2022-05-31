import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/model/user.dart';

class Primera extends StatefulWidget {
  const Primera({Key? key}) : super(key: key);

  @override
  State<Primera> createState() => _PrimeraState();
}

class _PrimeraState extends State<Primera> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: StreamBuilder<Usuari>(
              stream: currentUserStream(),
              builder: (BuildContext context, AsyncSnapshot<Usuari> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    throw ErrorWidget(
                        "Estat 'none' al StreamBuilder de l'usuari");
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    return ErrorWidget(
                        "L'Stream de l'usuari s'ha acabat! No hauria...");
                  case ConnectionState.active:
                    var usuari = snapshot.data!;
                    return Text("Ratxa: ${usuari.racha}");
                }
              },
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopUpGeneral(context, "Tutorials"),
                  );
                },
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                child: const Text("Tutorials"),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopUpGeneral(context, "Precaucions"),
                  );
                },
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                child: const Text("Precaucions"),
              ),
              StreamBuilder<Usuari>(
                stream: currentUserStream(),
                builder:
                    (BuildContext context, AsyncSnapshot<Usuari> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      throw ErrorWidget(
                          "Estat 'none' al StreamBuilder de l'usuari");
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      return ErrorWidget(
                          "L'Stream de l'usuari s'ha acabat! No hauria...");
                    case ConnectionState.active:
                      var usuari = snapshot.data!;
                      return ElevatedButton(
                        onPressed: () {
                          if (usuari.ultimo_cambio.day != DateTime.now().day) {
                            usuari.toggleContactLenses();
                            if (!usuari.portaLentilles) {
                              usuari.userActionUpdate();
                              var difference = -usuari.tiempoCuentaCreada
                                  .difference(DateTime.now())
                                  .inDays;
                              if (difference <= 5) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const _buildPopUpFeedback());
                              }
                            }
                          }
                        },
                        child: Text(
                          usuari.portaLentilles
                              ? 'Treure Lents'
                              : "Posar Lents",
                          style: usuari.ultimo_cambio.day == DateTime.now().day
                              ? TextStyle(color: Colors.grey[600])
                              : const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                      );
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopUpGeneral(context, "Classificació"),
                  );
                },
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                child: const Text("Classificació"),
              ),
            ],
          ),
          StreamBuilder<Usuari>(
            stream: currentUserStream(),
            builder: (BuildContext context, AsyncSnapshot<Usuari> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  throw ErrorWidget(
                      "Estat 'none' al StreamBuilder de l'usuari");
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return ErrorWidget(
                      "L'Stream de l'usuari s'ha acabat! No hauria...");
                case ConnectionState.active:
                  var usuari = snapshot.data!;
                  return ElevatedButton(
                      onPressed: () {
                        if (usuari.ultimo_cambio.day != DateTime.now().day &&
                            !usuari.portaLentilles) {
                          usuari.userActionUpdate();
                        }
                      },
                      child: Text(
                        "No me les he ficat",
                        style: usuari.ultimo_cambio.day == DateTime.now().day ||
                                usuari.portaLentilles
                            ? TextStyle(color: Colors.grey[600])
                            : const TextStyle(color: Colors.white),
                      ));
              }
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildPopUpGeneral(BuildContext context, String name) {
  return AlertDialog(
    title: Text(name),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[],
    ),
    actions: <Widget>[
      name == "Classificació"
          ? SizedBox(
              width: MediaQuery.of(context).size.height * 2 / 3,
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("usuarios")
                    .orderBy("puntos", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      throw ErrorWidget(
                          "Estat 'none' al StreamBuilder de l'usuari");
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      return ErrorWidget(
                          "L'Stream de l'usuari s'ha acabat! No hauria...");
                    case ConnectionState.active:
                      return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                                "${snapshot.data!.docs[index]['nombre']}       ${snapshot.data!.docs[index]['puntos'].toString()}"),
                          );
                        },
                      );
                  }
                },
              ),
            )
          : Container(),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Tancar'),
      ),
    ],
  );
}

bool posar = false, durant = false, treure = false;

class _buildPopUpFeedback extends StatefulWidget {
  const _buildPopUpFeedback({Key? key}) : super(key: key);

  @override
  State<_buildPopUpFeedback> createState() => __buildPopUpFeedbackState();
}

class __buildPopUpFeedbackState extends State<_buildPopUpFeedback> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Com estàs?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[],
      ),
      actions: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.height * 2 / 3,
          height: MediaQuery.of(context).size.height * 2 / 3,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("usuarios")
                .orderBy("puntos", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  throw ErrorWidget(
                      "Estat 'none' al StreamBuilder de l'usuari");
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return ErrorWidget(
                      "L'Stream de l'usuari s'ha acabat! No hauria...");
                case ConnectionState.active:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Tutorials",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: const [
                            Tutorial_Box(text: "Posar Lents"),
                            Tutorial_Box(text: "Conservar Lents"),
                            Tutorial_Box(text: "Treure Lents")
                          ]),
                      SizedBox(
                        height: 20,
                        child: Row(
                          children: [
                            const Text("Dificultats al posarte les lents?"),
                            Checkbox(
                                value: posar,
                                onChanged: (val) {
                                  setState(() {
                                    posar = val!;
                                  });
                                })
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Row(
                          children: [
                            const Text("Dificultats durante el dia?"),
                            Checkbox(
                                value: durant,
                                onChanged: (val) {
                                  setState(() {
                                    durant = val!;
                                  });
                                })
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Row(
                          children: [
                            const Text("Dificultats al treure les lents?"),
                            Checkbox(
                                value: treure,
                                onChanged: (val) {
                                  setState(() {
                                    treure = val!;
                                  });
                                })
                          ],
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final db = FirebaseFirestore.instance
                .collection("usuarios")
                .doc(FirebaseAuth.instance.currentUser?.email)
                .collection("tutoriales");
            db.add({
              'dif_posar': posar,
              'dif_durant': durant,
              'dif_treure': treure
            });

            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

class Tutorial_Box extends StatelessWidget {
  final String text;
  const Tutorial_Box({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(35))),
      height: 25,
      width: 25,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        const Icon(Icons.photo),
        Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}

class Question extends StatefulWidget {
  final String text;
  final int type;
  const Question({Key? key, required this.text, required this.type})
      : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    bool value = false;

    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Text(widget.text),
          Checkbox(
              value: value,
              onChanged: (val) {
                setState(() {
                  value = val!;
                  switch (widget.type) {
                    case 0:
                      posar = value;
                      break;
                    case 1:
                      durant = value;
                      break;
                    case 2:
                      treure = value;
                      break;
                    default:
                  }
                });
              })
        ],
      ),
    );
  }
}
