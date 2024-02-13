// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:neptun_plus_flutter/src/api_calls.dart' as api_calls;

class MessageDetailsScreen extends StatefulWidget {
  MessageDetailsScreen(
      {super.key,
      required this.id,
      required this.subject,
      required this.details,
      required this.isNew,
      required this.author,
      required this.sendDate});
  int id;
  String subject;
  String details;
  bool isNew;
  String author;
  String sendDate;

  @override
  State<MessageDetailsScreen> createState() => _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends State<MessageDetailsScreen> {
  @override
  void initState() {
    super.initState();
    setMessagetoRead();
  }

  setMessagetoRead() async {
    bool? success = await api_calls.setReadedMessages(widget.id);
    if (success == null || success == false) {
      Fluttertoast.showToast(msg: 'Üzenet olvasottnak jelölése sikertelen!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.author),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Text(
              widget.subject,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: HtmlWidget(
              widget.details,
              onTapUrl: (p0) => launchUrl(Uri.parse(p0)),
            ),
          ),
        ],
      ),
    );
  }
}
