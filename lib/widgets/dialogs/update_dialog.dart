import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:neptun_plus_flutter/src/updater.dart';

// ignore: must_be_immutable
class UpdateDialog extends StatelessWidget {
  UpdateDialog({super.key, required this.changelog});
  String changelog;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Új frissítés érhető el!',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize),
              ),
            ),
            const Text(
                'Egy új verzió érhető el, kérlek frissíts, hogy megkapd a legújabb feautre-öket és bugfixeket!'),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Mi változott:',
                style: TextStyle(fontSize: 24),
              ),
            ),
            MarkdownBody(data: changelog,shrinkWrap: true, styleSheet: MarkdownStyleSheet(blockSpacing: 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Később')),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: FilledButton(onPressed: () => downloadUpdate(), child: const Text('Frissítés')),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
