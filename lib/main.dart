import 'package:driver_lagbe/view/landing_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:driver_lagbe/view/signin.dart';
import 'package:driver_lagbe/view/signup.dart';
import 'package:driver_lagbe/view/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ড্রাইভার লাগবে?",
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {
        '/': (context) => new LandingPage(),
        '/signIn': (context) => new SignIn(),
        '/signUp': (context) => new SignUp(),
        '/home': (context) => new Home(),
      },
    );
  }
}



