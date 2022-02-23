import 'package:flutter/material.dart';
import 'package:optica/app.dart';
import 'package:intl/intl.dart';

class Configuration_1 extends StatefulWidget {
  const Configuration_1({Key key}) : super(key: key);

  @override
  State<Configuration_1> createState() => _Configuration_1State();
}

class _Configuration_1State extends State<Configuration_1> {
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
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
                  SmallText(text: "Lents"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainInput(),
                      SizedBox(width: 30),
                      MainInput(),
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
                  SmallText(text: "Estoig"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainInput(),
                      SizedBox(width: 30),
                      MainInput(),
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
                  SmallText(text: "Solució"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainInput(),
                      SizedBox(width: 30),
                      MainInput(),
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
                    SmallText(text: "Revisió"),
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
                    )
                  ]),
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
            ),
            Expanded(flex: 1, child: Container())
          ]),
        ),
      ),
    );
  }
}

class MainInput extends StatelessWidget {
  final text;
  const MainInput({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 120,
      height: 65,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "dubte",
          ),
        ),
      ),
    );
  }
}
