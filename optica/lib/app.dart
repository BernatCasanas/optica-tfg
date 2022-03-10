import 'package:flutter/material.dart';
import 'package:optica/configuration_1.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const Expanded(
                  flex: 2,
                  child: BigText(text: "NomApp"),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
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
                const Expanded(
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
  final String text;

  const BigText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }
}

class SmallText extends StatelessWidget {
  final String text;

  const SmallText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class _Button extends StatelessWidget {
  final String name;
  const _Button({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Configuration1()),
        );
      },
      child: Text(name),
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50), shape: const StadiumBorder(), primary: Colors.grey),
    );
  }
}

class _InputBox extends StatelessWidget {
  final String name;
  const _InputBox({
    Key? key,
    required this.name,
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
          const SizedBox(
            height: 35,
            child: TextField(
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
