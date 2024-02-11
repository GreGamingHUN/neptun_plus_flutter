// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'api_calls.dart' as api_calls;
import 'package:neptun_plus_flutter/logic.dart' as logic;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? selected;
  bool loginEnabled = false;
  bool loggingIn = false;
  TextEditingController neptunCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode neptunCodeField = FocusNode();
  FocusNode passwordField = FocusNode();

  @override
  void initState() {
    super.initState();
    getInstitutesList();
  }

  Set<DropdownMenuItem<String>> fasz = {};

  void getInstitutesList() async {
    List<dynamic> response = await api_calls.getInstitutes();
    for (var element in response) {
      if (element["Url"] != null) {
        fasz.add(DropdownMenuItem<String>(
          value: element["Url"],
          child: Text(logic.trimString(element["Name"].toString(), 27)),
        ));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            'Neptun Plus!',
            style: TextStyle(fontSize: 32),
          ),
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DropdownButtonFormField(
                    hint: const Text('Válassz intézményt...'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    items: fasz.toList(),
                    onChanged: (value) {
                      setState(() {
                        selected = value;
                        loginEnabled = true;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: TextFormField(
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(passwordField),
                    focusNode: neptunCodeField,
                    controller: neptunCodeController,
                    decoration: InputDecoration(
                        labelText: 'Neptunkód',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    focusNode: passwordField,
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Jelszó',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
              ],
            ),
          ),
          IconButton.filled(
              onPressed: (loginEnabled == true
                  ? () async {
                      setState(() {
                        loginEnabled = false;
                        loggingIn = true;
                      });
                      int loginSuccess = await api_calls.neptunLogin(
                          neptunCodeController.text,
                          passwordController.text,
                          selected);

                      switch (loginSuccess) {
                        case 200:
                          GoRouter.of(context).pushReplacement('/home');
                          break;
                        case 403:
                          setState(() {
                            loginEnabled = true;
                            loggingIn = false;
                          });
                          Fluttertoast.showToast(
                              msg: "Hibás neptunkód vagy jelszó!");
                          break;
                        case 408:
                          setState(() {
                            loginEnabled = true;
                            loggingIn = false;
                          });
                          Fluttertoast.showToast(msg: "Szerver időtúllépés!");
                          break;
                        default:
                          setState(() {
                            loginEnabled = true;
                            loggingIn = false;
                          });
                          Fluttertoast.showToast(msg: "Ismeretlen hiba!");
                          break;
                      }
                    }
                  : null),
              icon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: (loggingIn == true
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.send)),
              ))
        ],
      ),
    ));
  }
}
