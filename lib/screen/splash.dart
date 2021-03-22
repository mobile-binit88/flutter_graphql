import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterwithgraphql/screen/authentication/login_page.dart';
import 'package:flutterwithgraphql/screen/fetch_employee_detail.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BuildContext _context;
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigationPage() {
    Navigator.pushReplacement(
        _context, MaterialPageRoute(builder: (_context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SafeArea(
      child: new Scaffold(
        backgroundColor: Colors.blue,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ScaleAnimatedTextKit(
                text: ["Flutter GraphQL And Firebase"],
                textStyle: TextStyle(
                  fontSize: 30.0,
                  fontFamily: "Canterbury",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart),
          ),
        ),
      ),
    );
  }
}
