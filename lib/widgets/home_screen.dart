import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neptun_plus_flutter/widgets/account_dialog.dart';
import 'package:neptun_plus_flutter/widgets/messages_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_calls.dart' as api_calls;

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

  Future<bool> initSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map>? institutes = await api_calls.getTrainings();
    if (institutes != null) {
      prefs.setString("trainingDescription", institutes[0]["Description"]);
    } else {
      Fluttertoast.showToast(msg: "Képzések lekérése sikertelen!");
    }
    return true;
  }

  bool switchState = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initSetup(),
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.hasError) {
            if (snapshot.hasError) {
              Fluttertoast.showToast(msg: snapshot.error.toString());
            }
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
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
