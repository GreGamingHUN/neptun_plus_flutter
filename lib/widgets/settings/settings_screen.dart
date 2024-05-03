import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                    child: Text('Üzenetek'),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Órarend'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('Tárgyak'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('Vizsgák'),
                  )
                ],
                onChanged: (int? value) async {
                  bool success = await setDefaultPage(value);
                  Fluttertoast.showToast(msg: '${success ? 'Sikeres' : 'Sikertelen'} mentés');
                },
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
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
