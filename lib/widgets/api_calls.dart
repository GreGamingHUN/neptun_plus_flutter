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
  "CurrentPage": 0,
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

Future<List?> getCurriculums() async {
  bool loggedIn = await checkLogin();
  if (!loggedIn) {
    return null;
  }
  Uri url = await createEndpointUrl(endpoints.getCurriculums);
  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];

  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      return responseBody['CurriculumList'];
    }
  } on SocketException {
    return null;
  }
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

Future<List?> getMessages(int currentPage) async {
  if (!(await checkLogin())) {
    return null;
  }
  Uri url = await createEndpointUrl(endpoints.getMessages);

  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];
  body["CurrentPage"] = currentPage;
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

Future<List?> getExams(termId, bool added) async {
  if (!(await checkLogin())) {
    return null;
  }

  Uri url = await createEndpointUrl(endpoints.getExams);
  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];

  body["filter"] = {"ExamType": (added ? 1 : 0), "Term": termId};

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

Future<List?> getSubjects(termId, String? subjectName, int currentPage) async {
  if (!(await checkLogin())) {
    return null;
  }

  Uri url = await createEndpointUrl(endpoints.getSubjects);
  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];
  body["CurrentPage"] = 1;
  body["filter"] = {
    "TermId": termId,
    "SubjectName": subjectName,
    "CurriculumID": (await getCurriculums())?[0]["ID"],
  };

  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      return responseBody["SubjectList"];
    }
  } on SocketException {
    return null;
  }
}

Future<List?> getCourses(subjectId, termId) async {
  if (!(await checkLogin())) {
    return null;
  }

  Uri url = await createEndpointUrl(endpoints.getCourses);
  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];
  body["filter"] = {
    "TermID": termId,
    "Id": subjectId,
    "CurriculumID": (await getCurriculums())?[0]["ID"],
  };

  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      return responseBody["CourseList"];
    }
  } on SocketException {
    return null;
  }
}

Future<List?> getCalendarData(DateTime day) async {
  if (!(await checkLogin())) {
    return null;
  }

  Uri url = await createEndpointUrl(endpoints.getCalendarData);
  Map loginDetails = await getLoginDetails();

  Map<dynamic, dynamic> body = defaultBody;
  body["UserLogin"] = loginDetails["neptunCode"];
  body["Password"] = loginDetails["password"];

  Map<dynamic, dynamic> calendarData = {
    "needAllDaylong": false,
    "Time": true,
    "Exam": true,
    "Task": true,
    "Apointment": true,
    "RegisterList": true,
    "Consultation": true,
    "startDate": "/Date(${day.millisecondsSinceEpoch})/",
    "endDate": "/Date(${day.millisecondsSinceEpoch})/",
    "entityLimit": 0,
    "TotalRowCount": -1
  };

  body.addAll(calendarData);
  print(body);
  try {
    Response response =
        await http.post(url, body: jsonEncode(body), headers: defaultHeader);
    Map responseBody = jsonDecode(response.body);
    if (responseBody["ErrorMessage"] == null) {
      return responseBody["calendarData"];
    }
  } on SocketException {
    return null;
  }
}
