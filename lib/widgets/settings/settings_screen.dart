import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neptun_plus_flutter/src/updater.dart';
import 'package:neptun_plus_flutter/widgets/dialogs/update_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion = '';

  @override
  void initState() {
    getVersion();
    super.initState();
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
      body: Expanded(
          child: ListView(
        children: [
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
      )),
    );
  }
}
