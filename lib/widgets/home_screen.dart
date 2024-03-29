import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neptun_plus_flutter/src/updater.dart';
import 'package:neptun_plus_flutter/widgets/dialogs/account_dialog.dart';
import 'package:neptun_plus_flutter/widgets/dialogs/update_dialog.dart';
import 'package:neptun_plus_flutter/widgets/settings/settings_screen.dart';
import 'package:neptun_plus_flutter/widgets/subjects/added_subjects_screen.dart';
import 'package:neptun_plus_flutter/widgets/exams/exams_screen.dart';
import 'package:neptun_plus_flutter/widgets/messages/messages_screen.dart';
import 'package:neptun_plus_flutter/widgets/calendar/calendar_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neptun_plus_flutter/src/api_calls.dart' as api_calls;

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
    checkUpdate();
  }

    void checkUpdate() async {
    String? updateAvailable = await checkForUpdate();
    if (updateAvailable != null) {
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context) => UpdateDialog(changelog: updateAvailable,));
    } else {
    }
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
  List<String> pageNames = [
    'Üzenetek',
    'Órarend',
    'Felvett Tárgyak',
    'Felvett Vizsgák'
  ];
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
                  title: Text(pageNames[_currentPageIndex]),
                  centerTitle: true,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen(),));
                    }, icon: const Icon(Icons.settings_outlined)),
                  ),
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
                  TimeTableScreen(),
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
