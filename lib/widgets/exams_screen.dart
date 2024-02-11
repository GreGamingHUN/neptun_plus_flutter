// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:neptun_plus_flutter/logic.dart';
import 'package:neptun_plus_flutter/widgets/add_exam_screen.dart';
import 'package:neptun_plus_flutter/widgets/exam_details_screen.dart';
import 'api_calls.dart' as api_calls;

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  bool isLoadingTerms = true;
  bool isLoadingExams = false;
  Set<DropdownMenuItem<String>> periodTermList = {};
  List examsList = [];
  String? selectedTermId;

  ScrollController scrollViewController = ScrollController();
  bool floatingActionVisible = true;

  @override
  void initState() {
    super.initState();
    getPeriodTermsList();
    scrollViewController.addListener(() {
      if (scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (floatingActionVisible == true) {
          setState(() {
            floatingActionVisible = false;
          });
        }
      } else {
        if (scrollViewController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (floatingActionVisible == false) {
            setState(() {
              floatingActionVisible = true;
            });
          }
        }
      }
    });
  }

  void getPeriodTermsList() async {
    List? periodTerms = await api_calls.getPeriodTerms();
    if (periodTerms == null) return;
    for (var element in periodTerms) {
      periodTermList.add(DropdownMenuItem<String>(
        value: element["Id"].toString(),
        child: Text(element["TermName"]),
      ));
    }
    setState(() {
      isLoadingTerms = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    (isLoadingTerms
                        ? const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: CircularProgressIndicator(),
                          )
                        : const SizedBox(
                            width: 0,
                          )),
                    SizedBox(
                        width: 200,
                        height: 60,
                        child: DropdownButtonFormField(
                          hint: const Text('Válassz félévet'),
                          items: periodTermList.toList(),
                          onChanged: (value) async {
                            selectedTermId = value;
                            setState(() {
                              isLoadingExams = true;
                            });
                            List? exams = await api_calls.getExams(value, true);

                            setState(() {
                              examsList = exams ?? [];
                              isLoadingExams = false;
                            });
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ))
                  ],
                ),
              ),
            ),
            (isLoadingExams
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox()),
            Expanded(
              child: ListView.builder(
                controller: scrollViewController,
                itemCount: examsList.length,
                itemBuilder: (context, index) {
                  return ExamCard(
                    subjectCode: examsList[index]["SubjectCode"],
                    subjectName: examsList[index]["SubjectName"],
                    subjectComplianceResult: examsList[index]
                        ["SubjectComplianceResult"],
                    examType: examsList[index]["ExamType"],
                    startDate: examsList[index]["FromDate"],
                    endDate: examsList[index]["ToDate"],
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: selectedTermId != null,
        maintainAnimation: true,
        maintainState: true,
        maintainInteractivity: false,
        child: AnimatedOpacity(
          opacity: floatingActionVisible ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddExamScreen(termId: selectedTermId),
              )),
              label: const Text('Felvétel'),
              icon: const Icon(Icons.post_add_rounded),
            ),
          ),
        ),
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  ExamCard(
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trimString(subjectName ?? '', 30),
                  style: const TextStyle(fontSize: 16),
                ),
                Text(examType ?? 'Nincs követelmény'),
              ],
            ),
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamDetailsScreen(
                        subjectName: subjectName,
                        examType: examType,
                        subjectComplianceResult: subjectComplianceResult,
                        subjectCode: subjectCode,
                        startDate: startDate,
                        endDate: endDate,
                        applyToExam: false,
                      ),
                    )),
                icon: const Icon(Icons.info_outline))
          ],
        ),
      ),
    );
  }
}
