import 'package:flutter/material.dart';
import 'package:optica/app.dart';
import 'package:intl/intl.dart';

import 'configuration_2.dart';

class Configuration1 extends StatefulWidget {
  const Configuration1({Key? key}) : super(key: key);

  @override
  State<Configuration1> createState() => _Configuration1State();
}

class _Configuration1State extends State<Configuration1> {
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(children: [
            //Total flex = 12
            Expanded(
              flex: 1,
              child: Container(),
            ),
            const Expanded(
              child: BigText(text: "Configuració"),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SmallText(text: "Lents"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      MainInput(text: "Vida útil"),
                      SizedBox(width: 30),
                      MainInput(text: "Avís"),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SmallText(text: "Estoig"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      MainInput(text: "Vida útil"),
                      SizedBox(width: 30),
                      MainInput(text: "Avís"),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SmallText(text: "Solució"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      MainInput(text: "Vida útil"),
                      SizedBox(width: 30),
                      MainInput(text: "Avís"),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SmallText(text: "Revisió"),
                    TextButton(
                      child: Text(_dateTime == null
                          ? "Tria una data"
                          : DateFormat("yyyy-MM-dd").format(_dateTime!)),
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
                    )
                  ]),
            ),
            Expanded(
              flex: 0,
              child: TextButton(
                child: const Text("Continuar", style: TextStyle(fontSize: 10)),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 40),
                    shape: const StadiumBorder(),
                    primary: Colors.grey,
                    onPrimary: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Configuration2()),
                  );
                },
              ),
            ),
            Expanded(flex: 1, child: Container())
          ]),
        ),
      ),
    );
  }
}

class MainInput extends StatelessWidget {
  final String text;
  const MainInput({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 65,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: text,
          ),
        ),
      ),
    );
  }
}
