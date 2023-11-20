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
              return MessageCard(
                author: snapshot.data![index]["Name"],
                details: snapshot.data![index]["Detail"],
                isNew: snapshot.data![index]["IsNew"],
                sendDate: snapshot.data![index]["SendDate"],
                subject: snapshot.data![index]["Subject"],
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
      required this.subject,
      required this.details,
      required this.isNew,
      required this.author,
      required this.sendDate}) {
    details = logic.trimCSSfromMessage(details);
  }

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
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageDetailsScreen(
                subject: widget.subject,
                details: widget.details,
                isNew: widget.isNew,
                author: widget.author,
                sendDate: widget.sendDate),
          )),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                logic.trimString(widget.subject, 40),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        widget.isNew ? FontWeight.bold : FontWeight.normal),
              ),
              Text(
                logic.trimString(logic.trimCSSfromMessage(widget.details), 40),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        widget.isNew ? FontWeight.bold : FontWeight.normal),
              )
            ],
          ),
        ),
      ),
    );
  }
}
