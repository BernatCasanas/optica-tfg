import 'package:flutter/material.dart';
import 'package:optica/model/alertes.dart';
import 'package:optica/utils/dates.dart';

class Alertes extends StatefulWidget {
  const Alertes({Key? key}) : super(key: key);

  @override
  State<Alertes> createState() => _AlertesState();
}

const List<Icon> iconaAlerta = [
  Icon(Icons.remove_red_eye),
  Icon(Icons.camera_sharp),
  Icon(Icons.water),
  Icon(Icons.record_voice_over_sharp),
  Icon(Icons.star),
];

class _AlertesState extends State<Alertes> {
  TextEditingController person = TextEditingController();

  DateTime? _date = DateTime.now();
  TimeOfDay? _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: StreamBuilder(
              stream: getUserAlerts(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Alerta>> snapshot) {
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  child: ListTile(
                                    trailing: TextButton(
                                      onPressed: () => alerta.delete(),
                                      child: const Icon(Icons.close,
                                          color: Colors.black),
                                    ),
                                    leading: iconaAlerta[alerta.tipo],
                                    title: !justName
                                        ? Text(
                                            "Canviar ${Avisos.values.elementAt(alerta.tipo).name.toLowerCase()}")
                                        : Text(title),
                                    subtitle: Text(tempsRestant(alerta.tiempo)),
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
                      stream: getUserAlerts(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Alerta>> snapshot) {
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
                                              initialDate: DateTime.now().add(
                                                  const Duration(seconds: 1)),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2100),
                                            ).then((value) {
                                              setState(() {
                                                _date = value;
                                              });
                                            });
                                          },
                                          child: Text(
                                              "${_date!.day}/${_date!.month}/${_date!.year}"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay(
                                                  hour: DateTime.now().hour,
                                                  minute:
                                                      DateTime.now().minute),
                                            ).then((value) {
                                              _time = value;
                                            });
                                          },
                                          child: Text(
                                              "${_time!.hour}:${_time!.minute}"),
                                        ),
                                      ],
                                    ),
                                    TextField(
                                      controller: person,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Nom alerta",
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(100, 40),
                                        shape: const StadiumBorder(),
                                        primary: Colors.grey,
                                        onPrimary: Colors.black,
                                        elevation: 0,
                                      ),
                                      onPressed: () async {
                                        final novaAlerta = Alerta(person.text,
                                            _date!, Avisos.personalitzat.index);
                                        await novaAlerta.save();
                                      },
                                      child: const Text("Guardar",
                                          style: TextStyle(fontSize: 10)),
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
                },
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(300, 40),
              shape: const StadiumBorder(),
              primary: Colors.grey[400],
              onPrimary: Colors.black,
            ),
            child: const Text("Alerta Personalitzada"),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
