// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/src/logic.dart' as logic;

class ExamDetailsScreen extends StatelessWidget {
  ExamDetailsScreen(
      {super.key,
      required this.subjectName,
      required this.examType,
      required this.subjectComplianceResult,
      required this.subjectCode,
      required this.startDate,
      required this.endDate,
      required this.applyToExam});

  String? subjectName;
  String? examType;
  String? subjectComplianceResult;
  String? subjectCode;
  String? startDate;
  String? endDate;
  bool applyToExam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Részletek'),
      ),
      floatingActionButton: (applyToExam
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                  icon: Icon(Icons.post_add_rounded),
                  onPressed: null,
                  label: Text('Jelentkezés')),
            )
          : null),
      body: Column(
        children: [
          Text(subjectName ?? 'Nincs név'),
          Text(examType ?? 'Nincs követelmény'),
          Text(subjectCode ?? 'Nincs tárgykód'),
          Text(logic.formatDate(startDate ?? '', forceFullDate: true)),
          Text(logic.formatDate(endDate ?? '', forceFullDate: true))
        ],
      ),
    );
  }
}
