import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/src/logic.dart' as logic;

class CalendarDetailsScreen extends StatelessWidget {
  const CalendarDetailsScreen(
      {super.key,
      required this.allDayLong,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.location,
      required this.title});

  final bool allDayLong;
  final String description;
  final String startDate;
  final String endDate;
  final String location;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Részletek'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Esemény neve: $title'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Leírás: $description'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Helyszín: $location'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Esemény kezdete: ${logic.formatDate(startDate, forceFullDate: true)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Esemény vége: ${logic.formatDate(endDate, forceFullDate: true)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Egész napos esemény: ${allDayLong ? 'Igen' : 'Nem'}'),
            )
          ],
        ),
      ),
    );
  }
}
