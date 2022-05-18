import 'package:flutter/material.dart';
import 'package:optica/model/user.dart';
import 'package:optica/widgets/alertes.dart';
import 'package:optica/widgets/calendari.dart';
import 'package:optica/widgets/editar.dart';
import 'package:optica/widgets/ofertes.dart';
import 'package:optica/widgets/primera.dart';

class Page {
  final Widget widget;
  final String name;
  const Page(this.name, this.widget);
}

const List<Page> pages = [
  Page("Alertes", Alertes()),
  Page("Calendari", Calendari()),
  Page("Primera", Primera()),
  Page("Ofertes", Ofertes()),
  Page("Editar", Editar()),
];

int indexPage = 2;

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
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: signOut,
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
              icon: const Icon(Icons.home),
              onPressed: () {
                indexPage = 2;
                notifyParent();
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag),
              onPressed: () {
                indexPage = 3;
                notifyParent();
              },
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  indexPage = 4;
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

