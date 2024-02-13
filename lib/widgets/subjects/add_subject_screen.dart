// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/src/api_calls.dart' as api_calls;
import 'package:neptun_plus_flutter/src/logic.dart' as logic;

class AddSubjectScreen extends StatefulWidget {
  AddSubjectScreen({super.key, required this.termId});

  String termId;

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  String? subjectName;

  List subjectsList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api_calls.getSubjects(widget.termId, subjectName, 1),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Hiba történt az adatok lekérése közben'),
          );
        }
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tárgyfelvétel'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      onPressed: () async {
                        subjectName = await showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController subject =
                                TextEditingController();
                            return AlertDialog(
                              content: TextFormField(
                                controller: subject,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Mégsem')),
                                FilledButton(
                                    onPressed: () =>
                                        Navigator.pop(context, subject.text),
                                    child: const Text('Keresés'))
                              ],
                            );
                          },
                        );
                        if (subjectName != null) {
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.search)),
                )
              ],
            ),
            body: AddSubjectBody(
              subjectsList: snapshot.data,
              termId: widget.termId,
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class AddSubjectBody extends StatefulWidget {
  AddSubjectBody({super.key, required this.subjectsList, required this.termId});

  List? subjectsList;
  String termId;

  @override
  State<AddSubjectBody> createState() => _AddSubjectBodyState();
}

class _AddSubjectBodyState extends State<AddSubjectBody> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.subjectsList!.length + 1,
      itemBuilder: (context, index) {
        if (index >= widget.subjectsList!.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                  onPressed: () {},
                  child: const Text('további tárgyak betöltése')),
            ),
          );
        }

        return Column(
          children: [
            ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CoursesListDialog(
                        subjectId: widget.subjectsList?[index]['SubjectId'],
                        termId: widget.termId),
                  );
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(logic.trimString(
                        widget.subjectsList?[index]['SubjectName'], 40)),
                  ],
                ),
                subtitle: Text(
                    '${'${widget.subjectsList?[index]['SubjectSignupType']} · ${widget.subjectsList?[index]['Credit']}'} kredit')),
            const Divider(
              height: 1,
            )
          ],
        );
      },
    );
  }
}

class CoursesListDialog extends StatelessWidget {
  CoursesListDialog({super.key, required this.subjectId, required this.termId});
  int subjectId;
  String termId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Kurzusok',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: api_calls.getCourses(subjectId, termId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Hiba történt'),
                  );
                }

                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(logic.trimString(
                                snapshot.data?[index]["CourseTimeTableInfo"],
                                35)),
                            subtitle:
                                Text(snapshot.data?[index]["CourseTutor"]),
                          ),
                          const Divider(
                            height: 1,
                          )
                        ],
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
