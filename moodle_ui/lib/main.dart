import 'package:flutter/material.dart';
import 'package:moodle_ui/routes.dart';
import 'package:moodle_ui/screens/home/root_screen.dart';

void main() =>
    runApp(new MaterialApp(
      title: 'Moodle',
      home:RootScreen(),
    ));

class LoginApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Moodle UI',
      theme: ThemeData.dark(),
      routes: routes,
    );
  }
}
