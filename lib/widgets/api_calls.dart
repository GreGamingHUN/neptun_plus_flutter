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

Future<bool> checkLogin() async {
  Map loginDetails = await getLoginDetails();
  bool? loggedIn = loginDetails["loggedIn"];
  String? neptunCode = loginDetails["neptunCode"];
  String? password = loginDetails["password"];
  if (loggedIn == null || neptunCode == null || password == null) {
    return false;
  }
  return true;
}

Future<Map> getLoginDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map details = {
    "loggedIn": prefs.getBool("loggedIn"),
    "neptunCode": prefs.getString("neptunCode"),
    "password": prefs.getString("password"),
    "instituteUrl": prefs.getString("instituteUrl")
  };
  return details;
}

Future<int> neptunLogin(neptunCode, password, instituteUrl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Uri url = await createEndpointUrl(endpoints.getMessages,
      instituteUrl: instituteUrl);
  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = neptunCode;
  body["Password"] = password;
  try {
    Response response = await http.post(url,
        body: jsonEncode(defaultBody), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
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

Future<Uri> createEndpointUrl(endpoint, {instituteUrl}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (instituteUrl != null) {
    return Uri.parse('$instituteUrl/$endpoint');
  }
  return Uri.parse('${prefs.getString("instituteUrl")}/$endpoint');
}

Future<List<Map>?> getTrainings() async {
  bool loggedIn = await checkLogin();
  if (!loggedIn) {
    return null;
  }
  Uri url = await createEndpointUrl(endpoints.getTrainings);
  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];

  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      List<Map> tmp = [];
      for (var element in responseBody["TrainingList"]) {
        tmp.add({
          "Code": element["Code"],
          "Description": element["Description"],
          "Id": element["Id"]
        });
      }
      return tmp;
    }
  } on SocketException {
    return null;
  }
}

Future<List?> getMessages() async {
  if (!(await checkLogin())) {
    return null;
  }
  Uri url = await createEndpointUrl(endpoints.getMessages);

  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];

  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      return responseBody["MessagesList"];
    }
  } on SocketException {
    return null;
  }
}

Future<List?> getPeriodTerms() async {
  if (!(await checkLogin())) {
    return null;
  }
  Uri url = await createEndpointUrl(endpoints.getPeriodTerms);

  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];

  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      return responseBody["PeriodTermsList"];
    }
  } on SocketException {
    return null;
  }
}

Future<List?> getAddedSubjects(termId) async {
  if (!(await checkLogin())) {
    return null;
  }
  Uri url = await createEndpointUrl(endpoints.getAddedSubjects);
  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];

  body["TermId"] = termId;

  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      return responseBody["AddedSubjectsList"];
    }
  } on SocketException {
    return null;
  }
}

Future<bool?> setReadedMessages(messageId) async {
  if (!(await checkLogin())) {
    return null;
  }
  Uri url = await createEndpointUrl(endpoints.setReadedMessage);

  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];

  body["PersonMessageId"] = messageId;

  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      return true;
    }
  } on SocketException {
    return null;
  }
}

Future<List?> getExams(termId) async {
  if (!(await checkLogin())) {
    return null;
  }

  Uri url = await createEndpointUrl(endpoints.getExams);
  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];

  body["filter"] = {"ExamType": 0, "Term": termId};

  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      return responseBody["ExamList"];
    }
  } on SocketException {
    return null;
  }
}
