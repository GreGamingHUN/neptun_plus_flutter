import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/logic.dart';
import 'api_calls.dart' as api_calls;

class AddedSubjectsScreen extends StatefulWidget {
  const AddedSubjectsScreen({super.key});

  @override
  State<AddedSubjectsScreen> createState() => _AddedSubjectsScreenState();
}

class _AddedSubjectsScreenState extends State<AddedSubjectsScreen> {
  bool isLoadingTerms = true;
  bool isLoadingSubjects = false;
  Set<DropdownMenuItem<String>> periodTermList = {};
  List addedSubjectsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPeriodTermsList();
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
                            setState(() {
                              isLoadingSubjects = true;
                            });
                            List? addedSubjects =
                                await api_calls.getAddedSubjects(value);

                            setState(() {
                              addedSubjectsList = addedSubjects ?? [];
                              isLoadingSubjects = false;
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
            (isLoadingSubjects
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox()),
            Expanded(
              child: ListView.builder(
                itemCount: addedSubjectsList.length,
                itemBuilder: (context, index) {
                  return AddedSubjectCard(
                    subjectCode: addedSubjectsList[index]["SubjectCode"],
                    subjectName: addedSubjectsList[index]["SubjectName"],
                    subjectComplianceResult: addedSubjectsList[index]
                        ["SubjectComplianceResult"],
                    subjectCredit: addedSubjectsList[index]["SubjectCredit"],
                    subjectRequirement: addedSubjectsList[index]
                        ["SubjectRequirement"],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddedSubjectCard extends StatelessWidget {
  AddedSubjectCard(
      {super.key,
      required this.subjectName,
      required this.subjectRequirement,
      required this.subjectComplianceResult,
      required this.subjectCode,
      required this.subjectCredit});
  String? subjectName;
  String? subjectRequirement;
  String? subjectComplianceResult;
  String? subjectCode;
  String? subjectCredit;

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
                Text(trimString(subjectName ?? '', 25) ?? 'Nincs név'),
                Text(subjectRequirement ?? 'Nincs követelmény'),
              ],
            ),
            Text('${subjectCredit ?? "?"} kredit')
          ],
        ),
      ),
    );
  }
}
