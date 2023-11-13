import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/widgets/account_dialog.dart';
import 'package:neptun_plus_flutter/widgets/messages_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  bool switchState = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Neptun Plus!'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                          alignment: Alignment.topCenter,
                          content: AccountDialog()),
                    );
                  },
                  icon: const Icon(Icons.account_circle_outlined)),
            )
          ],
        ),
        body: const [
          MessagesScreen(),
          MessagesScreen(),
          MessagesScreen(),
          MessagesScreen()
        ][_currentPageIndex],
        bottomNavigationBar: NavigationBar(
            selectedIndex: _currentPageIndex,
            onDestinationSelected: (value) {
              setState(() {
                _currentPageIndex = value;
              });
            },
            destinations: [
              NavigationDestination(
                  icon: Icon((_currentPageIndex == 0
                      ? Icons.mail
                      : Icons.mail_outlined)),
                  label: "Üzenetek"),
              NavigationDestination(
                  icon: Icon((_currentPageIndex == 1
                      ? Icons.calendar_month
                      : Icons.calendar_month_outlined)),
                  label: "Órarend"),
              NavigationDestination(
                  icon: Icon((_currentPageIndex == 2
                      ? Icons.book
                      : Icons.book_outlined)),
                  label: "Tárgyak"),
              NavigationDestination(
                  icon: Icon((_currentPageIndex == 3
                      ? Icons.bookmark
                      : Icons.bookmark_outline)),
                  label: "Vizsgák"),
            ]),
      ),
    );
  }
}
