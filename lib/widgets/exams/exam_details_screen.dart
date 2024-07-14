// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neptun_plus_flutter/src/logic.dart' as logic;
import 'package:neptun_plus_flutter/src/api_calls.dart' as api_calls;

class ExamDetailsScreen extends StatelessWidget {
  ExamDetailsScreen(
      {super.key,
      required this.subjectName,
      required this.examType,
      required this.subjectComplianceResult,
      required this.subjectCode,
      required this.startDate,
      required this.endDate,
      required this.applyToExam,
      required this.examID});

  String? subjectName;
  String? examType;
  String? subjectComplianceResult;
  String? subjectCode;
  String? startDate;
  String? endDate;
  String? examID;
  bool applyToExam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Részletek'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
            icon: const Icon(Icons.post_add_rounded),
            onPressed: () async {
              String? examSigningResult =
                  await api_calls.setExamSigning(examID, applyToExam);
              if (examSigningResult == "") {
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg:
                        "Sikeres ${applyToExam ? "jelentkezés a vizsgára" : "leadás"}!");
              } else {
                Fluttertoast.showToast(msg: examSigningResult ?? "Ismeretlen hiba");
              }
            },
            label: Text(applyToExam ? 'Jelentkezés' : 'Leadás')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subjectName ?? 'Nincs név',
                style: const TextStyle(fontSize: 30)),
            Text(examType ?? 'Nincs követelmény',
            style: const TextStyle(fontSize: 20)),
            Text(subjectCode ?? 'Nincs tárgykód'),
            Text("Kezdés: ${logic.formatDate(startDate ?? '', forceFullDate: true)}"),
            Text("Vége: ${logic.formatDate(endDate ?? '', forceFullDate: true)}")
          ],
        ),
      ),
    );
  }
}
