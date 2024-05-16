import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    getDefaultPage();
    checkPageOrder();
  }

  void getDefaultPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentPageIndex = prefs.getInt('defaultPage') ?? 0;
    setState(() {});
  }

  void checkUpdate() async {
    String? updateAvailable = await checkForUpdate();
    if (updateAvailable != null) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) => UpdateDialog(
                changelog: updateAvailable,
              ));
    } else {}
  }

  List<Widget> pages = [
    MessagesScreen(),
    TimeTableScreen(),
    AddedSubjectsScreen(),
    ExamsScreen()
  ];

  void checkPageOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> pageOrder = prefs.getStringList('pageOrder') ?? [];
    List<Map<String, dynamic>> pageOrderMap = [];
    for (String page in pageOrder) {
      pageOrderMap.add(jsonDecode(page));
    }
    if (pageOrder.isNotEmpty) {
      List<Widget> newPages = [];
      List<String> newPageNames = [];
      List<Icon> newIcons = [];
      for (Map<String, dynamic> page in pageOrderMap) {
        newPageNames.add(page.values.first);
        switch (page.keys.first) {
          case 'messages':
            newPages.add(MessagesScreen());
            newIcons.add(Icon(Icons.mail_outlined));
            break;
          case 'timetable':
            newPages.add(TimeTableScreen());
            newIcons.add(Icon(Icons.calendar_month_outlined));
            break;
          case 'subjects':
            newPages.add(AddedSubjectsScreen());
            newIcons.add(Icon(Icons.book_outlined));
            break;
          case 'exams':
            newPages.add(ExamsScreen());
            newIcons.add(Icon(Icons.bookmark_outline));
            break;
          default:
            Fluttertoast.showToast(msg: "Hiba történt az oldalok betöltésekor!");
        }
      }
      pages = newPages;
      pageNames = newPageNames;
      pageIcons = newIcons;
      setState(() {});
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
    'Tárgyak',
    'Vizsgák'
  ];

  List<Icon> pageIcons = [
    const Icon(Icons.mail_outlined),
    const Icon(Icons.calendar_month_outlined),
    const Icon(Icons.book_outlined),
    const Icon(Icons.bookmark_outline)
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
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ));
                        },
                        icon: const Icon(Icons.settings_outlined)),
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
                body: pages[_currentPageIndex],
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SalomonBottomBar(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    items: [
                      SalomonBottomBarItem(
                          icon: pageIcons[0],
                          title: Text(pageNames[0])),
                      SalomonBottomBarItem(
                          icon: pageIcons[1],
                          title: Text(pageNames[1])),
                      SalomonBottomBarItem(
                          icon: pageIcons[2],
                          title: Text(pageNames[2])),
                      SalomonBottomBarItem(
                          icon: pageIcons[3],
                          title: Text(pageNames[3])),
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
