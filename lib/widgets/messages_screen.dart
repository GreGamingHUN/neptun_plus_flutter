import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neptun_plus_flutter/widgets/message_details_screen.dart';
import 'api_calls.dart' as api_calls;
import 'package:neptun_plus_flutter/logic.dart' as logic;

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api_calls.getMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  MessageCard(
                    id: snapshot.data![index]["Id"],
                    author: snapshot.data![index]["Name"],
                    details: snapshot.data![index]["Detail"],
                    isNew: snapshot.data![index]["IsNew"],
                    sendDate: snapshot.data![index]["SendDate"],
                    subject: snapshot.data![index]["Subject"],
                  ),
                  const Divider(
                    height: 1,
                  )
                ],
              );
            },
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
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
      tag: widget.id.toString(),
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessageDetailsScreen(
                    id: widget.id,
                    subject: widget.subject,
                    details: widget.details,
                    isNew: widget.isNew,
                    author: widget.author,
                    sendDate: widget.sendDate))),
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
