import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/model/alertes.dart';
import 'package:optica/model/user.dart';
import 'package:optica/screens/configura2_graduacio.dart';
import 'package:table_calendar/table_calendar.dart';

class Page {
  final Widget widget;
  final String name;
  const Page(this.name, this.widget);
}

const List<Page> pages = [
  Page("Alertes", Alertes()),
  Page("Calendari", Calendari()),
  Page("Ofertes", Ofertes()),
  Page("Editar", Editar()),
];

int indexPage = 0;

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _NavigatorBar(notifyParent: refresh),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[400],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pages[indexPage].name,
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder<Usuari>(
                        stream: currentUserStream(),
                        builder: (BuildContext context, AsyncSnapshot<Usuari> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              throw ErrorWidget("Estat 'none' al StreamBuilder de l'usuari");
                            case ConnectionState.waiting:
                              return const Center(child: CircularProgressIndicator());
                            case ConnectionState.done:
                              return ErrorWidget("L'Stream de l'usuari s'ha acabat! No hauria...");
                            case ConnectionState.active:
                              var usuari = snapshot.data!;
                              return ElevatedButton(
                                onPressed: () => usuari.toggleContactLenses(),
                                child: Text(
                                  usuari.portaLentilles ? 'Treure Lents' : "Posar Lents",
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  textStyle: const TextStyle(fontSize: 15),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                                ),
                              );
                          }
                        },
                      ),
                      TextButton(
                        onPressed: FirebaseAuth.instance.signOut,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.grey,
                          ),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.logout, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 13,
            child: pages[indexPage].widget,
          )
        ],
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
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today_rounded),
              onPressed: () {
                indexPage = 1;
                notifyParent();
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag),
              onPressed: () {
                indexPage = 2;
                notifyParent();
              },
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  indexPage = 3;
                  notifyParent();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Pantalles que després aniràn en diferents arxius

class Alertes extends StatefulWidget {
  const Alertes({Key? key}) : super(key: key);

  @override
  State<Alertes> createState() => _AlertesState();
}

class _AlertesState extends State<Alertes> {
  TextEditingController person = TextEditingController();

  DateTime? _date = DateTime.now();
  TimeOfDay? _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: StreamBuilder(
              stream: getUserAlerts(),
              builder: (BuildContext context, AsyncSnapshot<List<Alerta>> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: snapshot.data!.map<Widget>((alerta) {
                            bool justName = false;
                            String title = "";
                            if (alerta.tipo == 3) {
                              justName = true;
                              title = "Revisió";
                            }
                            if (alerta.tipo == 4) {
                              justName = true;
                              title = alerta.nombre;
                            }
                            return Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  width: 350,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.all(Radius.circular(20))),
                                  child: ListTile(
                                    trailing: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection("usuarios")
                                                .doc(FirebaseAuth.instance.currentUser?.email)
                                                .collection("avisos")
                                                .doc(alerta.id)
                                                .delete();
                                          });
                                        },
                                        child: const Icon(Icons.close, color: Colors.black)),
                                    leading: alerta.tipo == 0
                                        ? const Icon(Icons.remove_red_eye)
                                        : alerta.tipo == 1
                                            ? const Icon(Icons.camera_sharp)
                                            : alerta.tipo == 2
                                                ? const Icon(Icons.water)
                                                : alerta.tipo == 3
                                                    ? const Icon(Icons.record_voice_over_sharp)
                                                    : const Icon(Icons.star),
                                    title: !justName
                                        ? Text("Canviar ${Avisos.values.elementAt(alerta.tipo).name.toLowerCase()}")
                                        : Text(title),
                                    subtitle: Text(alerta.tiempo.difference(DateTime.now()).inDays > 1
                                        ? "Queden ${alerta.tiempo.difference(DateTime.now()).inDays.toString()} dies"
                                        : alerta.tiempo.difference(DateTime.now()).inHours > 0
                                            ? "Queden ${alerta.tiempo.difference(DateTime.now()).inHours.toString()} hores"
                                            : alerta.tiempo.difference(DateTime.now()).inMinutes > 0
                                                ? "Queden ${alerta.tiempo.difference(DateTime.now()).inMinutes.toString()} minuts"
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
                            .doc(FirebaseAuth.instance.currentUser!.email.toString())
                            .collection("avisos")
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            return SizedBox(
                                height: 200,
                                width: 250,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                        TextButton(
                                            onPressed: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now().add(const Duration(seconds: 1)),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                              ).then((value) {
                                                setState(() {
                                                  _date = value;
                                                });
                                              });
                                            },
                                            child: Text("${_date!.day}/${_date!.month}/${_date!.year}")),
                                        TextButton(
                                            onPressed: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime:
                                                    TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                                              ).then((value) {
                                                _time = value;
                                              });
                                            },
                                            child: Text("${_time!.hour}:${_time!.minute}")),
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
                                        child: const Text("Guardar", style: TextStyle(fontSize: 10)),
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(100, 40),
                                            shape: const StadiumBorder(),
                                            primary: Colors.grey,
                                            onPrimary: Colors.black),
                                        onPressed: () {
                                          db
                                              .collection("usuarios")
                                              .doc(FirebaseAuth.instance.currentUser?.email.toString())
                                              .collection("avisos")
                                              .add({
                                            'tiempo': DateTime(
                                                _date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute),
                                            'tipo': Avisos.personalitzat.index,
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
  // DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
  }

  @override
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
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay1, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDay1 = selectedDay;
                // _focusedDay = focusedDay;
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
                    "Dia",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Avisos i Historial")
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

class Editar extends StatelessWidget {
  const Editar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> texts = {"Obrir Blister", "Obrir Solució", "Canviar Estoig", "Canviar Graduació"}.toList();

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
                            height: index != 0 ? 30 : 90,
                            child: index == 0
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Introdueix vida útil"),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        controller: controller,
                                      ),
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
                                if (controller.text != "" && controller1.text != "" && index == 0) {
                                  canPop = true;
                                } else if (index != 0) {
                                  canPop = true;
                                }

                                if (!canPop) return;

                                var dir = FirebaseFirestore.instance
                                    .collection("usuarios")
                                    .doc(FirebaseAuth.instance.currentUser?.email)
                                    .collection("avisos");

                                var dir2 = FirebaseFirestore.instance
                                    .collection("usuarios")
                                    .doc(FirebaseAuth.instance.currentUser?.email)
                                    .collection("historial");

                                var today = DateTime.now();

                                switch (index) {
                                  case 0:
                                    dir.add({
                                      'tipo': Avisos.lents.index,
                                      'tiempo': today.add(Duration(days: int.parse(controller.text))),
                                    });
                                    FirebaseFirestore.instance
                                        .collection("usuarios")
                                        .doc(FirebaseAuth.instance.currentUser?.email)
                                        .update({'duración_diaria': int.parse(controller1.text)});
                                    dir2.add({
                                      'tipo': Historial.blister.index,
                                      'fecha': DateTime.now(),
                                    });
                                    break;
                                  case 1:
                                    dir.add({
                                      'tipo': Avisos.solucio.index,
                                      'tiempo': today.add(const Duration(days: 60)),
                                    });
                                    dir2.add({
                                      'tipo': Historial.solucio.index,
                                      'fecha': DateTime.now(),
                                    });
                                    break;
                                  case 2:
                                    dir.add({
                                      'tipo': Avisos.estoig.index,
                                      'tiempo': today.add(const Duration(days: 90)),
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
                      MaterialPageRoute(builder: (context) => const Configura2Graduacio(fromEditScreen: true)),
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
                          .doc(FirebaseAuth.instance.currentUser!.email.toString())
                          .collection("historial")
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              String subtitle = "${_date!.day}/${_date.month}/${_date.year}";

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
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text(
                      "Espai per afegir més editables",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
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
