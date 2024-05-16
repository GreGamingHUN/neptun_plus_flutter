import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:neptun_plus_flutter/src/logic.dart';
import 'package:neptun_plus_flutter/src/updater.dart';
import 'package:neptun_plus_flutter/widgets/dialogs/update_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion = '';
  int defaultPage = 0;
  bool isOrderChanged = false;

  @override
  void initState() {
    getVersion();
    getDefaultPage();
    super.initState();
  }

  void getDefaultPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultPage = prefs.getInt('defaultPage') ?? 0;
    setState(() {});
  }

  Future<bool> setDefaultPage(int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt('defaultPage', value ?? 0);
  }

  void getVersion() async {
    appVersion = 'v${await getAppVersion()}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beállítások'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              appVersion,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Kezdőlap'),
            trailing: SizedBox(
              width: 200,
              child: DropdownButtonFormField(
                value: defaultPage,
                items: const [
                  DropdownMenuItem(
                    value: 0,
                    child: Text('1. oldal'),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('2. oldal'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('3. oldal'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('4. oldal'),
                  )
                ],
                onChanged: (int? value) async {
                  bool success = await setDefaultPage(value);
                  Fluttertoast.showToast(
                      msg: '${success ? 'Sikeres' : 'Sikertelen'} mentés');
                },
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          ListTile(
            title: const Text('Oldalak sorrendje'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const PageOrderSelector(),
              ).then((value) {
                if (value != null && value == true) {
                  isOrderChanged = true;
                }
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Frissítések keresése'),
            onTap: () async {
              String? updateAvailable = await checkForUpdate();
              if (updateAvailable != null) {
                // ignore: use_build_context_synchronously
                showDialog(
                    context: context,
                    builder: (context) => UpdateDialog(
                          changelog: updateAvailable,
                        ));
              } else {
                Fluttertoast.showToast(msg: 'Nincs elérhető frissítés');
              }
            },
          )
        ],
      ),
    );
  }
}

class PageOrderSelector extends StatefulWidget {
  const PageOrderSelector({
    super.key,
  });

  @override
  State<PageOrderSelector> createState() => _PageOrderSelectorState();
}

class _PageOrderSelectorState extends State<PageOrderSelector> {
  List<Map<String, dynamic>> pages = [];
  @override
  void initState() {
    getPages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Oldalak sorrendje',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 300,
              height: 270,
              child: ReorderableListView.builder(
                itemBuilder: (context, index) => ListTile(
                  key: Key(index.toString()),
                  title: Text(pages[index].values.first),
                ),
                itemCount: pages.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final Map<String, dynamic> item = pages.removeAt(oldIndex);
                    pages.insert(newIndex, item);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Mégse'),
                    ),
                  ),
                  FilledButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      List<String> pageOrder = [];
                      for (Map<String, dynamic> page in pages) {
                        pageOrder.add(jsonEncode(page));
                      }
                      prefs.setStringList('pageOrder', pageOrder);
                      Navigator.pop(context, true);
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: const Text('Figyelmeztetés'),
                        content: const Text('Az oldalak sorrendjének módosításához újraindítás szükséges!'),
                        actions: [
                          TextButton(onPressed: () => GoRouter.of(context).go('/'), child: const Text('Újraindítás')),
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Később')),],
                      ),);
                    },
                    child: const Text('Mentés'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getPages() async {
    pages = await getPageOrder();
    setState(() {});
  }
}
