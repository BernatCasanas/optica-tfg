import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/model/user.dart';
import 'package:optica/utils/event.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendari extends StatefulWidget {
  const Calendari({Key? key}) : super(key: key);

  @override
  State<Calendari> createState() => _CalendariState();
}

class _CalendariState extends State<Calendari> {
  DateTime selectedDay1 = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("usuarios")
            .doc(FirebaseAuth.instance.currentUser?.email)
            .collection("avisos")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            selectedEvents.clear();
            snapshot.data?.docs.forEach(
              (doc) {
                DateTime date = doc["tiempo"].toDate();
                var nombre = doc['nombre'];
                date = DateTime(date.year, date.month, date.day);
                if (selectedEvents[date] != null) {
                  selectedEvents[date]?.add(Event(title: nombre));
                } else {
                  selectedEvents[date] = [Event(title: nombre)];
                }
              },
            );

            return Column(
              children: [
                TableCalendar(
                  locale: "es_ES",
                  headerStyle: const HeaderStyle(formatButtonVisible: false),
                  firstDay: DateTime.utc(2022, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
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
                  eventLoader: _getEventsfromDay,
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10),
                          ..._getEventsfromDay(selectedDay1)
                              .map((e) => ListTile(
                                    title: Text(e.title),
                                  )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
