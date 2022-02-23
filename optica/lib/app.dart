import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/configuration_1.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: BigText(text: "NomApp"),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _InputBox(name: "Nom"),
                      SizedBox(height: 12),
                      _InputBox(name: "Codi Deontologic"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 0,
                  child: _Button(name: "Accedeix"),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BigText extends StatelessWidget {
  final text;

  const BigText({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }
}

class SmallText extends StatelessWidget {
  final text;

  const SmallText({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class _Button extends StatelessWidget {
  final name;
  const _Button({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Configuration_1()),
        );
      },
      child: Text(name),
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50),
          shape: const StadiumBorder(),
          primary: Colors.grey),
    );
  }
}

class _InputBox extends StatelessWidget {
  final name;
  const _InputBox({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          Container(
            height: 35,
            child: const TextField(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
