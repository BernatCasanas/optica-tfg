import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/model/alertes.dart';
import 'package:optica/model/user.dart';
import 'package:optica/screens/configura2_graduacio.dart';

class Editar extends StatelessWidget {
  const Editar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> texts = {
      "Obrir Blister",
      "Obrir Solució",
      "Canviar Estoig",
      "Canviar Graduació"
    }.toList();

    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 4,
            itemBuilder: (BuildContext ctx, index) {
              return TextButton(
                onPressed: () {
                  if (index != 3) {
                    TextEditingController controller = TextEditingController();
                    TextEditingController controller1 = TextEditingController();
                    bool canPop = false;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(texts.elementAt(index)),
                          content: SizedBox(
                            height: index != 0 ? 30 : 140,
                            child: index == 0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Introdueix vida útil"),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        controller: controller,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text("Introdueix duració diaria"),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        controller: controller1,
                                      )
                                    ],
                                  )
                                : const Text("Es crearà un avís"),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("D'acord"),
                              onPressed: () {
                                canPop = true;
                                if (controller.text != "" &&
                                    controller1.text != "" &&
                                    index == 0) {
                                  canPop = true;
                                } else if (index != 0) {
                                  canPop = true;
                                }

                                if (!canPop) return;

                                var dir = getUserRef().collection("avisos");
                                var dir2 = getUserRef().collection("historial");
                                var today = DateTime.now();

                                switch (index) {
                                  case 0:
                                    dir.add({
                                      'tipo': Avisos.lents.index,
                                      'tiempo': today.add(Duration(
                                          days: int.parse(controller.text))),
                                    });
                                    FirebaseFirestore.instance
                                        .collection("usuarios")
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.email)
                                        .update({
                                      'duración_diaria':
                                          int.parse(controller1.text)
                                    });
                                    dir2.add({
                                      'tipo': Historial.blister.index,
                                      'fecha': DateTime.now(),
                                    });
                                    break;
                                  case 1:
                                    dir.add({
                                      'tipo': Avisos.solucio.index,
                                      'tiempo':
                                          today.add(const Duration(days: 60)),
                                    });
                                    dir2.add({
                                      'tipo': Historial.solucio.index,
                                      'fecha': DateTime.now(),
                                    });
                                    break;
                                  case 2:
                                    dir.add({
                                      'tipo': Avisos.estoig.index,
                                      'tiempo':
                                          today.add(const Duration(days: 90)),
                                    });
                                    dir2.add({
                                      'tipo': Historial.estoig.index,
                                      'fecha': DateTime.now(),
                                    });
                                    break;
                                  default:
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const Configura2Graduacio(fromEditScreen: true),
                      ),
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    texts[index],
                    style: const TextStyle(color: Colors.black),
                  ),
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        TextButton(
          child: const Text(
            "Historial",
          ),
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
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
                      stream: FirebaseFirestore.instance
                          .collection("usuarios")
                          .doc(FirebaseAuth.instance.currentUser!.email
                              .toString())
                          .collection("historial")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          return SizedBox(
                            height: 400,
                            width: 100,
                            child: ListView(
                                children: snapshot.data!.docs.map((e) {
                              String title = "";
                              IconData icon = Icons.star;
                              DateTime? _date = e['fecha'].toDate();
                              String subtitle =
                                  "${_date!.day}/${_date.month}/${_date.year}";

                              switch (e['tipo']) {
                                case 0:
                                  title = "Va canviar la graduació";
                                  icon = Icons.lens_blur;
                                  break;
                                case 1:
                                  title = "Es va posar les lents";
                                  icon = Icons.lens;
                                  break;
                                case 2:
                                  title = "Es va treure les lents";
                                  icon = Icons.lens_outlined;
                                  break;
                                case 3:
                                  title = "Va canviar d'estoig";
                                  icon = Icons.cached_sharp;
                                  break;
                                case 4:
                                  title = "Va obrir un blister";
                                  icon = Icons.opacity;
                                  break;
                                case 5:
                                  title = "Va obrir una solució";
                                  icon = Icons.water;
                                  break;
                                default:
                              }
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    title,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  subtitle: Text(subtitle),
                                  leading: Icon(icon),
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
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(child: Container()),
        )
      ],
    );
  }
}
