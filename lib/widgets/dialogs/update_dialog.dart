import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/src/updater.dart';

// ignore: must_be_immutable
class UpdateDialog extends StatelessWidget {
  UpdateDialog({super.key, required this.changelog});
  String changelog;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Új frissítés érhető el!', style: TextStyle(fontWeight: FontWeight.w600),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Egy új verzió érhető el, kérlek frissíts, hogy megkapd a legújabb feautre-öket és bugfixeket!'),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text('Mi változott:', style: TextStyle(fontSize: 24),),
          ),
          Text(changelog)
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Később')),
        FilledButton(onPressed: () {
          downloadUpdate();
        }, child: const Text('Frissítés'))
      ],
    );
  }
}