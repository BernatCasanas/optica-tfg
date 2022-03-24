import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
                                const SizedBox(height: 10),
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

class Progres extends StatefulWidget {
  const Progres({Key? key}) : super(key: key);

  @override
  State<Progres> createState() => _ProgresState();
}

class _ProgresState extends State<Progres> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Text(
                    "Titulo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Descripción"),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Ofertes extends StatelessWidget {
  const Ofertes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: Container(
            height: 120,
            width: 300,
            decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(35))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("data"),
                SizedBox(height: 20),
                Text("data"),
              ],
            ),
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("ofertas").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> offers = snapshot.data!.docs;
              return Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 334,
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
                        final expire = offers[index]['fecha_caduca'].toDate();
                        final now = DateTime.now();
                        final difference = now.difference(expire).inDays;
                        if (difference > 0) {
                          return _BoxOffer(
                              //hi ha algo que no em deix. si trec la condició em deix imprimirho
                              days: difference,
                              price: double.parse(offers[index]['precio']),
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
            children: const [
              Text("2d"),
              SizedBox(),
              Text("13,99€"),
            ],
          ),
          const Icon(Icons.photo),
          Column(
            children: const [
              Text(
                "data",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Text("data lorem impum")
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}

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
                onPressed: () {},
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    texts[index],
                    style: TextStyle(color: Colors.black),
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
          onPressed: () {},
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text(
                      "Situació actual del temps",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text("data"),
                    Text("data"),
                    Text("data"),
                    Text("data"),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
