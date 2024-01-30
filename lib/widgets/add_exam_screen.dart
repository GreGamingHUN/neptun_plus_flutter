import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/widgets/exam_details_screen.dart';
import 'api_calls.dart' as api_calls;
import 'package:neptun_plus_flutter/logic.dart' as logic;

class AddExamScreen extends StatelessWidget {
  AddExamScreen({super.key, required this.termId});

  String? termId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api_calls.getExams(termId, false),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Hiba történt az adatok lekérése közben'),
          );
        }
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Vizsgajelentkezés'),
            ),
            body: AddExamBody(examsList: snapshot.data),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class AddExamBody extends StatelessWidget {
  AddExamBody({super.key, required this.examsList});

  List? examsList;

  @override
  Widget build(BuildContext context) {
    RegExp regExp = RegExp(r'/Date\((\d+)\)/');

    examsList!.sort((a, b) {
      Match? matchA = regExp.firstMatch(a['FromDate']);
      int aNumber = int.parse(matchA!.group(1)!);

      Match? matchB = regExp.firstMatch(b['FromDate']);
      int bNumber = int.parse(matchB!.group(1)!);

      return aNumber.compareTo(bNumber);
    });
    return ListView.builder(
      itemCount: examsList?.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamDetailsScreen(
                      subjectName: examsList?[index]['SubjectName'],
                      examType: examsList?[index]['examType'],
                      subjectComplianceResult: examsList?[index]
                          ['subjectComplianceResult'],
                      subjectCode: examsList?[index]['subjectCode'],
                      startDate: examsList?[index]['FromDate'],
                      endDate: examsList?[index]['ToDate'],
                      applyToExam: true,
                    ),
                  )),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(examsList?[index]['SubjectName']),
                  Text(logic.formatDate(examsList?[index]['FromDate']))
                ],
              ),
              subtitle: Text(examsList?[index]['ExamType']),
            ),
            const Divider(
              height: 1,
            )
          ],
        );
      },
    );
  }
}
