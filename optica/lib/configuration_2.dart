import 'package:flutter/material.dart';
import 'package:optica/configuration_1.dart';
import 'package:intl/intl.dart';
import 'package:optica/principalApp.dart';

import 'app.dart';

class Configuration_2 extends StatefulWidget {
  const Configuration_2({Key key}) : super(key: key);

  @override
  State<Configuration_2> createState() => _Configuration_2State();
}

class _Configuration_2State extends State<Configuration_2> {
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              //Total flex = 12
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: BigText(text: "Configuració"),
              ),
              Expanded(
                flex: 7,
                child: Container(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LentInfo(),
                        SizedBox(width: 40),
                        _LentInfo(),
                      ],
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      child: Text(_dateTime == null
                          ? "Tria una data"
                          : DateFormat("yyyy-MM-dd").format(_dateTime)),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 40),
                          shape: const StadiumBorder(),
                          primary: Colors.grey,
                          onPrimary: Colors.black),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2030))
                            .then((date) {
                          setState(() {
                            _dateTime = date;
                          });
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      child: Text("Guardar", style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          shape: const StadiumBorder(),
                          primary: Colors.grey,
                          onPrimary: Colors.black),
                      onPressed: () {
                        //guardar a cloud
                      },
                    ),
                  ],
                )),
              ),
              Expanded(
                flex: 0,
                child: TextButton(
                  child: Text("Historial", style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 40),
                      shape: const StadiumBorder(),
                      primary: Colors.grey,
                      onPrimary: Colors.black),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => _PopUp(context));
                  },
                ),
              ),
              Expanded(
                flex: 0,
                child: TextButton(
                  child: Text("Continuar", style: TextStyle(fontSize: 10)),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      shape: const StadiumBorder(),
                      primary: Colors.grey,
                      onPrimary: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Principal()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _PopUp(BuildContext context) {
  return AlertDialog(
    title: const Text('Popup example'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hello"),
      ],
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
}

class _LentInfo extends StatelessWidget {
  const _LentInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Icon(Icons.remove_red_eye_outlined, size: 80),
        ),
        MainInput(),
        MainInput(),
        MainInput(),
        MainInput(),
      ],
    );
  }
}
