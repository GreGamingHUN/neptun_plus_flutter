import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neptun_plus_flutter/src/api_calls.dart' as api_calls;

class ChangePasswordWidget extends StatelessWidget {
  ChangePasswordWidget({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Jelszó változtatása'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  labelText: 'Új jelszó', border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 18.0),
            child: TextField(
              controller: passwordAgainController,
              decoration: const InputDecoration(
                  labelText: 'Új jelszó ismét', border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Mégse'),
        ),
        FilledButton(
          onPressed: () async {
            if (passwordController.text.isEmpty || passwordAgainController.text.isEmpty) {
              Fluttertoast.showToast(msg: 'A mezők kitöltése kötelező!');
              return;
            }
            if (passwordController.text != passwordAgainController.text) {
              Fluttertoast.showToast(msg: 'A két jelszó nem egyezik!');
              return;
            }
            String? success = await api_calls.setNewPassword(passwordController.text);
            if (success != null) {
              Fluttertoast.showToast(msg: success);
            } else {
              Fluttertoast.showToast(msg: 'Sikeres jelszóváltás!');
            }
            //Navigator.pop(context);
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
