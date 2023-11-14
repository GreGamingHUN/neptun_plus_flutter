import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class AccountDialog extends StatefulWidget {
  const AccountDialog({super.key});

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  bool darkMode = false;
  String neptunCode = "";
  String trainingName = "";
  late final SharedPreferences prefs;
  @override
  void initState() {
    getAccountData();
    super.initState();
  }

  getAccountData() async {
    prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool("darkMode");
    if (isDarkMode == null) {
      prefs.remove("loggedIn");
      setState(() {
        darkMode = false;
      });
    } else if (isDarkMode == true) {
      setState(() {
        darkMode = true;
      });
    }

    neptunCode = prefs.getString("neptunCode") ?? "";
    String? trainingNameTmp = prefs.getString("trainingDescription");

    trainingName = (trainingNameTmp!.length > 35
            ? "${trainingNameTmp.substring(0, 35)}..."
            : trainingNameTmp) ??
        "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            neptunCode,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(trainingName),
          SwitchListTile(
              value: darkMode,
              onChanged: (value) {
                if (value == true) {
                  ThemeProvider.controllerOf(context).setTheme("light");
                } else {
                  ThemeProvider.controllerOf(context).setTheme("dark");
                }
                darkMode = !darkMode;
                prefs.setBool("darkMode", darkMode);
              },
              title: const Text("Sötét mód")),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () {
                      GoRouter.of(context).pushReplacement('/login');
                      Fluttertoast.showToast(msg: "Sikeresen kijelentkezve!");
                    },
                    child: const Text('Kijelentkezés')),
              )
            ],
          )
        ],
      ),
    );
  }
}
