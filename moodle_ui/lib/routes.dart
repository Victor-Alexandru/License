import 'package:flutter/material.dart';
import 'package:moodle_ui/screens/home/home_page.dart';
import 'package:moodle_ui/screens/login/login_screen.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  // '/home':         (BuildContext context) => new HomePage(),
  '/' :          (BuildContext context) => new LoginScreen(),
};