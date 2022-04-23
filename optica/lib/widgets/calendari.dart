import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendari extends StatefulWidget {
  const Calendari({Key? key}) : super(key: key);

  @override
  State<Calendari> createState() => _CalendariState();
}

class _CalendariState extends State<Calendari> {
  DateTime selectedDay1 = DateTime.now();
  // DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: TableCalendar(
            locale: "es_ES",
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay1, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDay1 = selectedDay;
                // _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Text(
                    "Dia",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Avisos i Historial")
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
