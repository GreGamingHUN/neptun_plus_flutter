import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/logic.dart' as logic;

class ExamDetailsScreen extends StatelessWidget {
  ExamDetailsScreen(
      {super.key,
      required this.subjectName,
      required this.examType,
      required this.subjectComplianceResult,
      required this.subjectCode,
      required this.startDate,
      required this.endDate});

  String? subjectName;
  String? examType;
  String? subjectComplianceResult;
  String? subjectCode;
  String? startDate;
  String? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Részletek'),
      ),
      body: Column(
        children: [
          Text(subjectName ?? 'Nincs név'),
          Text(examType ?? 'Nincs követelmény'),
          Text(subjectCode ?? 'Nincs tárgykód'),
          Text(logic.formatDate(startDate ?? '')),
          Text(logic.formatDate(endDate ?? ''))
        ],
      ),
    );
  }
}
