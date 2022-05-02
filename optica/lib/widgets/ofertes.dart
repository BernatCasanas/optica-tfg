import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/model/user.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Ofertes extends StatefulWidget {
  const Ofertes({Key? key}) : super(key: key);

  @override
  State<Ofertes> createState() => _OfertesState();
}

class _OfertesState extends State<Ofertes> {
  @override
  Widget build(BuildContext context) {
    List<Color> level = [
      Colors.black,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.greenAccent,
      Colors.green,
    ];

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("usuarios")
          .doc(FirebaseAuth.instance.currentUser?.email.toString())
          .get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          var value = data!['nivel_recompensa'];
          var puntos = data['puntos'];
          return Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  height: 120,
                  width: 300,
                  decoration: BoxDecoration(
                      color: level.elementAt(value),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Nivell $value",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(height: 15),
                      Text(getLevel(value)),
                      const SizedBox(height: 4),
                      LinearPercentIndicator(
                        alignment: MainAxisAlignment.center,
                        width: 140.0,
                        lineHeight: 10.0,
                        percent: puntos / getMaxPoints(value),
                        barRadius: const Radius.circular(16),
                        backgroundColor: Colors.grey,
                        progressColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: (() {
                    setState(() {
                      addPoints(10);
                    });
                  }),
                  child: Text("+10 punts")),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ofertas")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
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
                                    description: offers[index]['descripción']);
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
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

String getLevel(int level) {
  switch (level) {
    case 1:
      return "Malament";
    case 2:
      return "Millorable";
    case 3:
      return "Acceptable";
    case 4:
      return "Correcte";
    case 5:
      return "Admirable";
    default:
      return "Sense Nivell";
  }
}

int getMaxPoints(int current) {
  List<int> nextLevel = [50, 150, 300, 500];
  return nextLevel[current - 1];
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
