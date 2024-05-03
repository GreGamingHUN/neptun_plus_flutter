import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String trimString(String input, int length) {
  return (input.length > length ? "${input.substring(0, length)}..." : input);
}

String trimCSSfromMessage(String message) {
  const String cssPostfix = "\t\t\r\n\t\r\n\t\r\n\t\t";
  if (message.contains(cssPostfix)) {
    return message.substring(message.lastIndexOf(cssPostfix) + 12);
  }
  return message;
}

String formatDate(String date,
    {bool forceDate = false,
    bool forceTime = false,
    bool forceFullDate = false}) {
  RegExp regExp = RegExp(r'/Date\((\d+)\)/');
  Match? match = regExp.firstMatch(date);

  if (match != null) {
    int dateNumber = int.parse(match.group(1)!);
    DateTime sendTime = DateTime.fromMillisecondsSinceEpoch(dateNumber);
    DateTime currentTime = DateTime.now();
    sendTime = sendTime.subtract(sendTime.timeZoneOffset);

    if (forceDate) return DateFormat('MM. dd.').format(sendTime);
    if (forceTime) return DateFormat('HH:mm').format(sendTime);
    if (forceFullDate) return DateFormat('MM. dd. HH:mm').format(sendTime);

    if (sendTime
            .compareTo(currentTime.subtract(const Duration(days: 1)))
            .abs() >
        0) {
      return DateFormat('MM. dd.').format(sendTime);
    }
    return DateFormat('HH:mm').format(sendTime);
  }
  return 'NaN';
}

Future<List<Map<String, dynamic>>> getPageOrder() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> pageOrder = prefs.getStringList('pageOrder') ?? [];

  List<Map<String, dynamic>> defaultOrderMap = [
    {'messages': 'Üzenetek'},
    {'timetable': 'Órarend'},
    {'subjects': 'Tárgyak'},
    {'exams': 'Vizsgák'}
  ];
  if (pageOrder.isEmpty) {
    return defaultOrderMap;
  }
  List<Map<String, dynamic>> orderMap = [];
  for (String page in pageOrder) {
    orderMap.add(jsonDecode(page));
  }
  return orderMap;
}
