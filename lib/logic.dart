import 'package:intl/intl.dart';

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
