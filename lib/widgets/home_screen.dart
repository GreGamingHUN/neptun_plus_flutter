import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neptun_plus_flutter/widgets/account_dialog.dart';
import 'package:neptun_plus_flutter/widgets/added_subjects_screen.dart';
import 'package:neptun_plus_flutter/widgets/exams_screen.dart';
import 'package:neptun_plus_flutter/widgets/messages_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
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
            return Scaffold(
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
                  AddedSubjectsScreen(),
                  ExamsScreen()
                ][_currentPageIndex],
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SalomonBottomBar(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    items: [
                      SalomonBottomBarItem(
                          icon: Icon((_currentPageIndex == 0
                              ? Icons.mail
                              : Icons.mail_outlined)),
                          title: const Text("Üzenetek")),
                      SalomonBottomBarItem(
                          icon: Icon((_currentPageIndex == 1
                              ? Icons.calendar_month
                              : Icons.calendar_month_outlined)),
                          title: const Text("Órarend")),
                      SalomonBottomBarItem(
                          icon: Icon((_currentPageIndex == 2
                              ? Icons.book
                              : Icons.book_outlined)),
                          title: const Text("Tárgyak")),
                      SalomonBottomBarItem(
                          icon: Icon((_currentPageIndex == 3
                              ? Icons.bookmark
                              : Icons.bookmark_outline)),
                          title: const Text("Vizsgák")),
                    ],
                    currentIndex: _currentPageIndex,
                    onTap: (p0) {
                      setState(() {
                        _currentPageIndex = p0;
                      });
                    },
                  ),
                ));
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
