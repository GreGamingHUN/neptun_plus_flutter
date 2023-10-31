import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neptun_plus_flutter/widgets/home_screen.dart';
import 'package:neptun_plus_flutter/widgets/login_screen.dart';

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (context, state) {
            return const LoginScreen();
          },
        )
      ])
]);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true
      ),
      routerConfig: _router,
    );
  }
}
