// ignore_for_file: use_build_context_synchronously

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neptun_plus_flutter/src/updater.dart';
import 'package:neptun_plus_flutter/widgets/home_screen.dart';
import 'package:neptun_plus_flutter/widgets/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (context, state) {
        return const CheckLogin();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: 'home',
          builder: (context, state) {
            return const HomeScreen();
          },
        )
      ])
]);

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        themes: [
          AppTheme(
              id: "dark",
              data: ThemeData(useMaterial3: true, colorScheme: lightDynamic),
              description: "Sötét mód"),
          AppTheme(
              id: "light",
              data: ThemeData(useMaterial3: true, colorScheme: darkDynamic),
              description: "Világos mód")
        ],
        child: ThemeConsumer(
          child: Builder(
            builder: (themeContext) => MaterialApp.router(
              theme: ThemeProvider.themeOf(themeContext).data,
              routerConfig: _router,
            ),
          ),
        ),
      );
    });
  }
}

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }


  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('loggedIn');
    if (loggedIn != null && loggedIn == true) {
      GoRouter.of(context).pushReplacement('/home');
    } else {
      GoRouter.of(context).pushReplacement('/login');
    }
  }
}
