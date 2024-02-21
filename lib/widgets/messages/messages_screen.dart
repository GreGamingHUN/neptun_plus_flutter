// ignore_for_file: must_be_immutable
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:neptun_plus_flutter/widgets/messages/message_details_screen.dart';
import 'package:neptun_plus_flutter/src/api_calls.dart' as api_calls;
import 'package:neptun_plus_flutter/src/logic.dart' as logic;

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int pageCount = 0;
  List messages = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  loadMessages() async {
    pageCount += 1;
    List<dynamic>? messagesResponse = await api_calls.getMessages(pageCount);
    setState(() {
      messages.addAll(messagesResponse!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      onEndOfPage: () async => await loadMessages(),
      scrollOffset: 200,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                MessageCard(
                  id: messages[index]["Id"],
                  author: messages[index]["Name"],
                  details: messages[index]["Detail"],
                  isNew: messages[index]["IsNew"],
                  sendDate: messages[index]["SendDate"],
                  subject: messages[index]["Subject"],
                ),
                const Divider(
                  height: 1,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class MessageCard extends StatefulWidget {
  MessageCard(
      {super.key,
      required this.id,
      required this.subject,
      required this.details,
      required this.isNew,
      required this.author,
      required this.sendDate}) {
    details = logic.trimCSSfromMessage(details);
  }
  int id;
  String subject;
  String details;
  bool isNew;
  String author;
  String sendDate;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: Random().nextInt(100).toString(),
      child: ListTile(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MessageDetailsScreen(
                      id: widget.id,
                      subject: widget.subject,
                      details: widget.details,
                      isNew: widget.isNew,
                      author: widget.author,
                      sendDate: widget.sendDate)));
          setState(() {
            widget.isNew = false;
          });
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  logic.trimString(widget.author, 40),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          widget.isNew ? FontWeight.bold : FontWeight.normal),
                ),
                Text(logic.formatDate(widget.sendDate))
              ],
            ),
            Text(
              logic.trimString(widget.subject, 40),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      widget.isNew ? FontWeight.bold : FontWeight.normal),
            )
          ],
        ),
        subtitle: Text(
          logic.trimString(logic.trimCSSfromMessage(widget.details), 40),
          style: TextStyle(
              fontSize: 14,
              fontWeight: widget.isNew ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }
}
