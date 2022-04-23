import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Ofertes extends StatelessWidget {
  const Ofertes({Key? key}) : super(key: key);

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
          return Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  height: 120,
                  width: 300,
                  decoration: BoxDecoration(
                      color: level.elementAt(value), borderRadius: const BorderRadius.all(Radius.circular(35))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Nivell $value",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(height: 20),
                      Text(getLevel(value)),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("ofertas").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final expire = offers[index]['fecha_caduca'].toDate();
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
      decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(35))),
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
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
