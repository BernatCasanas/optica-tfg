import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optica/utils/event.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendari extends StatefulWidget {
  const Calendari({Key? key}) : super(key: key);

  @override
  State<Calendari> createState() => _CalendariState();
}

class _CalendariState extends State<Calendari> {
  DateTime _selectedDay1 = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<DateTime, List<Event>> sortEvents(eventList) {
    Map<DateTime, List<Event>> eventMap = {};
    for (final event in eventList) {
      final DateTime tiempo = event["tiempo"].toDate();
      final nombre = event['nombre'];
      final date = DateTime.utc(tiempo.year, tiempo.month, tiempo.day);
      eventMap.putIfAbsent(date, () => []);
      eventMap[date]!.add(Event(title: nombre));
    }
    return eventMap;
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
          final eventMap = sortEvents(snapshot.data!.docs);
          debugPrint(eventMap.toString());
          return Column(
            children: [
              TableCalendar<Event>(
                locale: "es_ES",
                headerStyle: const HeaderStyle(formatButtonVisible: false),
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay1, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay1 = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                eventLoader: (DateTime date) {
                  debugPrint(date.toString());
                  return eventMap[date] ?? [];
                },
              ),
              Expanded(
                child: _EventsForDay(
                  events: eventMap[_selectedDay1] ?? [],
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _EventsForDay extends StatelessWidget {
  const _EventsForDay({
    Key? key,
    required this.events,
  }) : super(key: key);

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Events",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            ...events.map(
              (e) => ListTile(
                title: Text(e.title),
                tileColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
