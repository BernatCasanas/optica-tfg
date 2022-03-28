import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/configuration_1.dart';
import 'package:table_calendar/table_calendar.dart';

final pages = <Widget>[
  const Alertes(),
  const Calendari(),
  const Ofertes(),
  const Editar(),
];

DateTime? _date = DateTime.now();
TimeOfDay? _time = TimeOfDay.now();
TextEditingController person = TextEditingController();

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pages[indexPage].toString(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.logout,
                                    color: Colors.black),
                              ),
                            ),
                          ],
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

class Alertes extends StatefulWidget {
  const Alertes({Key? key}) : super(key: key);

  @override
  State<Alertes> createState() => _AlertesState();
}

class _AlertesState extends State<Alertes> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    setState(() {});
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
                                    title: e['tipo'] != 4
                                        ? Text(AVISOS.values
                                            .elementAt(e['tipo'])
                                            .name)
                                        : Text(e['nombre']),
                                    subtitle: Text(e['tiempo']
                                                .toDate()
                                                .difference(DateTime.now())
                                                .inDays >
                                            1
                                        ? "Queden ${e['tiempo'].toDate().difference(DateTime.now()).inDays.toString()} dies"
                                        : e['tiempo']
                                                    .toDate()
                                                    .difference(DateTime.now())
                                                    .inHours >
                                                0
                                            ? "Queden ${e['tiempo'].toDate().difference(DateTime.now()).inHours.toString()} hores"
                                            : e['tiempo']
                                                        .toDate()
                                                        .difference(
                                                            DateTime.now())
                                                        .inMinutes >
                                                    0
                                                ? "Queden ${e['tiempo'].toDate().difference(DateTime.now()).inMinutes.toString()} minuts"
                                                : "Ha vençut"),
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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alterta Personalitzada'),
                      content: StreamBuilder(
                        stream: db
                            .collection("usuarios")
                            .doc(FirebaseAuth.instance.currentUser!.email
                                .toString())
                            .collection("avisos")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            return SizedBox(
                                height: 200,
                                width: 250,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now()
                                                        .add(const Duration(
                                                            seconds: 1)),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2100),
                                                  ).then((value) {
                                                    setState(() {
                                                      _date = value;
                                                    });
                                                  });
                                                },
                                                child: Text(
                                                    "${_date!.day}/${_date!.month}/${_date!.year}")),
                                            TextButton(
                                                onPressed: () {
                                                  showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay(
                                                        hour:
                                                            DateTime.now().hour,
                                                        minute: DateTime.now()
                                                            .minute),
                                                  ).then((value) {
                                                    _time = value;
                                                  });
                                                },
                                                child: Text(
                                                    "${_time!.hour}:${_time!.minute}")),
                                          ]),
                                      TextField(
                                        controller: person,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 14),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Nom alerta",
                                        ),
                                      ),
                                      TextButton(
                                        child: const Text("Guardar",
                                            style: TextStyle(fontSize: 10)),
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(100, 40),
                                            shape: const StadiumBorder(),
                                            primary: Colors.grey,
                                            onPrimary: Colors.black),
                                        onPressed: () {
                                          db
                                              .collection("usuarios")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.email
                                                  .toString())
                                              .collection("avisos")
                                              .add({
                                            'tiempo': DateTime(
                                                _date!.year,
                                                _date!.month,
                                                _date!.day,
                                                _time!.hour,
                                                _time!.minute),
                                            'tipo': AVISOS.PERSONALITZAT.index,
                                            'nombre': person.text,
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ));
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

class Calendari extends StatefulWidget {
  const Calendari({Key? key}) : super(key: key);

  @override
  State<Calendari> createState() => _CalendariState();
}

class _CalendariState extends State<Calendari> {
  DateTime selectedDay1 = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> selectedEvents = {};

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: TableCalendar(
            locale: "es_ES",
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            eventLoader: _getEventsFromDay,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay1, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDay1 = selectedDay;
                _focusedDay = focusedDay;
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
                children: [
                  const Text(
                    "Titulo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ..._getEventsFromDay(selectedDay1)
                      .map((Event event) => ListTile(
                            title: Text(event.title),
                          )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Event {
  final String title;
  Event({required this.title});

  String getString() => this.title;
}

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
                      const SizedBox(height: 20),
                      Text(getLevel(value)),
                    ],
                  ),
                ),
              ),
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
      break;
    case 2:
      return "Millorable";
      break;
    case 3:
      return "Acceptable";
      break;
    case 4:
      return "Correcte";
      break;
    case 5:
      return "Admirable";
      break;
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
