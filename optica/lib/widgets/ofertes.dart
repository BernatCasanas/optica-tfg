import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:optica/model/user.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Ofertes extends StatefulWidget {
  const Ofertes({Key? key}) : super(key: key);

  @override
  State<Ofertes> createState() => _OfertesState();
}

class Level {
  final String description;
  final Color color;
  final int maxPoints;
  const Level(this.description, this.color, this.maxPoints);
}

const List<Level> allLevels = [
  Level("Malament", Colors.red, 50),
  Level("Millorable", Colors.orange, 100),
  Level("Acceptable", Colors.yellow, 200),
  Level("Correcte", Colors.greenAccent, 300),
  Level("Admirable", Colors.green, 500),
];

Level getLevel(int level) {
  assert(level >= 1 && level <= 5);
  return allLevels[level - 1];
}

class _OfertesState extends State<Ofertes> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Usuari>(
      stream: currentUserStream(),
      builder: (_, AsyncSnapshot<Usuari> snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final usuari = snapshot.data!;
          final level = usuari.nivellRecompensa;
          return Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  height: 120,
                  width: 300,
                  decoration: BoxDecoration(
                    color: getLevel(level).color,
                    borderRadius: const BorderRadius.all(Radius.circular(35)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Nivell ${usuari.nivellRecompensa}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(height: 15),
                      Text(getLevel(level).description),
                      const SizedBox(height: 4),
                      LinearPercentIndicator(
                        alignment: MainAxisAlignment.center,
                        width: 140.0,
                        lineHeight: 10.0,
                        percent: usuari.puntos / getLevel(level).maxPoints,
                        barRadius: const Radius.circular(16),
                        backgroundColor: Colors.grey,
                        progressColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => addPoints(10),
                child: const Text("+10 punts"),
              ),
              StreamBuilder(
                // TODO: Crear una clase Oferta i fer una funció ofertesStream()
                // semblant a currentUserStream()
                stream: FirebaseFirestore.instance
                    .collection("ofertas")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<DocumentSnapshot> offers = snapshot.data!.docs;
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 400,
                        width: 340,
                        child: GridView.builder(
                          itemCount: offers.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final expire =
                                offers[index]['fecha_caduca'].toDate();
                            final now = DateTime.now();
                            final difference = expire.difference(now).inDays;
                            if (difference > 0) {
                              return _BoxOffer(
                                days: difference,
                                price: offers[index]['precio'],
                                title: offers[index]['nombre'],
                                description: offers[index]['descripción'],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class _BoxOffer extends StatelessWidget {
  final int days;
  final double price;
  final String title;
  final String description;

  const _BoxOffer({
    Key? key,
    required this.days,
    required this.price,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(35))),
      height: 50,
      width: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(days.toString()),
              const SizedBox(),
              Text("${price.toString()}€"),
            ],
          ),
          const Icon(Icons.photo),
          Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                textAlign: TextAlign.center,
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}
