import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:neptun_plus_flutter/constants/urls.dart' as urls;
import 'package:neptun_plus_flutter/constants/endpoints.dart' as endpoints;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getInstitutes() async {
  Uri url = Uri.parse(urls.institutesUrl);
  Response response = await http.get(url);
  return jsonDecode(response.body);
}

Map<dynamic, dynamic> defaultBody = {
  "UserLogin": null,
  "Password": null,
  "CurrentPage": "0",
  "LCID": "1038"
};

Map<String, String> defaultHeader = {'Content-Type': 'application/json'};

Future<int> neptunLogin(neptunCode, password, instituteUrl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$instituteUrl/${endpoints.getMessages}');
  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = neptunCode;
  body["Password"] = password;
  try {
    Response response = await http.post(url,
        body: jsonEncode(defaultBody), headers: defaultHeader);
    Map<dynamic, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      prefs.setBool("loggedIn", true);
      prefs.setString("instituteUrl", instituteUrl);
      prefs.setString("neptunCode", neptunCode);
      prefs.setString("password", password);
      return 200;
    }
    return 403;
  } on SocketException {
    return 408;
  }
}
