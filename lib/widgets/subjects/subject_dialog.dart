import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neptun_plus_flutter/src/api_calls.dart' as api_calls;

class DialogDetails extends StatefulWidget {
  DialogDetails({super.key, required this.subjectName,
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
  State<DialogDetails> createState() => _DialogDetailsState();
}

class _DialogDetailsState extends State<DialogDetails> {
  var subjectDetails;
  bool canDelete = false;
  @override
  void initState() {
    if (widget.subjectComplianceResult == "" || widget.subjectComplianceResult == null) {
      widget.subjectComplianceResult = "Nincs jegy";
      canDelete = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(widget.subjectName ?? 'Nincs név', style: TextStyle(fontSize: 20),),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Követelmény: ${widget.subjectRequirement ?? 'Nincs követelmény'}'),
                Text('Jegy: ${widget.subjectComplianceResult}'),
                Text('Tárgykód: ${widget.subjectCode}'),
                Text('Kredit: ${widget.subjectCredit}'),
              ],
            ),
            (canDelete ? FilledButton.icon(onPressed: () async {
              String? deleteSubjectResult = await api_calls.deleteSubject(widget.subjectCode);
              if (deleteSubjectResult == "") {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Sikeres leadás!");
              } else {
                Fluttertoast.showToast(msg: deleteSubjectResult ?? "Ismeretlen hiba");
              }
            }, label: const Text('Leadás'), icon: const Icon(Icons.remove_circle_outline_rounded),) : const SizedBox()),
            
          ],
        ),
      ),
    );
  }
}