import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/src/updater.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Új frissítés érhető el!', style: TextStyle(fontWeight: FontWeight.w600),),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Egy új verzió érhető el, kérlek frissíts, hogy megkapd a legújabb feautre-öket és bugfixeket!'),
          Divider(),
          Text('A frissítés letölti az új apk file-t amit csak fel kell telepíteni.')
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