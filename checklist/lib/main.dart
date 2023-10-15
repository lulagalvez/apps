import 'package:flutter/material.dart';
import 'package:checklist/screens/blank.dart';
import 'package:checklist/screens/login_screen.dart';
import 'package:checklist/screens/sing_up_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MyFormLogin(),
        '/signup': (context) => const MyFormSingUp(),
        '/loginSuccess': (context) => const ToDo(
              name: '',
            ),
      },
    );
  }
}
