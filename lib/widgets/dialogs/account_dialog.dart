import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:neptun_plus_flutter/widgets/dialogs/change_password_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:neptun_plus_flutter/src/logic.dart' as logic;

class AccountDialog extends StatefulWidget {
  const AccountDialog({super.key});

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  bool darkMode = false;
  String neptunCode = "";
  String trainingName = "";
  String versionNumber = 'v';
  late final SharedPreferences prefs;
  @override
  void initState() {
    getAccountData();
    getVersionNumber();
    super.initState();
  }

  getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionNumber = versionNumber + packageInfo.version;
  }

  getAccountData() async {
    prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool("darkMode");
    if (isDarkMode == null) {
      darkMode = false;
    } else if (isDarkMode == true) {
      darkMode = true;
    }
    setState(() {
      neptunCode = prefs.getString("neptunCode") ?? "";
      String? trainingNameTmp = prefs.getString("trainingDescription");

      trainingName = logic.trimString(trainingNameTmp ?? "", 35);
    });
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(trainingName),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
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
                    ListTile(
                      title: const Text("Jelszó változtatása"),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(context: context, builder: (context) => ChangePasswordWidget(),);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                versionNumber,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: OutlinedButton(
                    onPressed: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('loggedIn', false);
                      // ignore: use_build_context_synchronously
                      GoRouter.of(context).pushReplacement('/login');
                      Fluttertoast.showToast(msg: "Sikeresen kijelentkezve!");
                    },
                    child: const Text('Kijelentkezés')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
