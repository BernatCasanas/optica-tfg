import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:optica/model/user.dart';

class Primera extends StatefulWidget {
  const Primera({Key? key}) : super(key: key);

  @override
  State<Primera> createState() => _PrimeraState();
}

class _PrimeraState extends State<Primera> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: StreamBuilder<Usuari>(
              stream: currentUserStream(),
              builder: (BuildContext context, AsyncSnapshot<Usuari> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    throw ErrorWidget(
                        "Estat 'none' al StreamBuilder de l'usuari");
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    return ErrorWidget(
                        "L'Stream de l'usuari s'ha acabat! No hauria...");
                  case ConnectionState.active:
                    var usuari = snapshot.data!;
                    return Text("Ratxa: ${usuari.racha}");
                }
              },
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context, "Tutorials"),
                  );
                },
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                child: Text("Tutorials"),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context, "Precaucions"),
                  );
                },
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                child: Text("Precaucions"),
              ),
              StreamBuilder<Usuari>(
                stream: currentUserStream(),
                builder:
                    (BuildContext context, AsyncSnapshot<Usuari> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      throw ErrorWidget(
                          "Estat 'none' al StreamBuilder de l'usuari");
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      return ErrorWidget(
                          "L'Stream de l'usuari s'ha acabat! No hauria...");
                    case ConnectionState.active:
                      var usuari = snapshot.data!;
                      return ElevatedButton(
                        onPressed: () => usuari.toggleContactLenses(),
                        child: Text(
                          usuari.portaLentilles
                              ? 'Treure Lents'
                              : "Posar Lents",
                        ),
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                      );
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context, "Classificació"),
                  );
                },
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                child: Text("Classificació"),
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context, String name) {
  return AlertDialog(
    title: Text(name),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    ),
    actions: <Widget>[
      name == "Classificació"
          ? SizedBox(
              width: MediaQuery.of(context).size.height * 2 / 3,
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("usuarios")
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      throw ErrorWidget(
                          "Estat 'none' al StreamBuilder de l'usuari");
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      return ErrorWidget(
                          "L'Stream de l'usuari s'ha acabat! No hauria...");
                    case ConnectionState.active:
                      return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                                "${snapshot.data!.docs[index]['nombre']}       ${snapshot.data!.docs[index]['puntos'].toString()}"),
                          );
                        },
                      );
                  }
                },
              ),
            )
          : Container(),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Tancar'),
      ),
    ],
  );
}
