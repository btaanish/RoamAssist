// @dart=3.0.5
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:roam_assist/constants.dart';
import 'package:roam_assist/views/main_screen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen()));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              "Roam Assist",
              style: TextStyle(
                  fontSize: 50.0, color: kTextColor, fontFamily: 'Poppins'),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            SpinKitFoldingCube(
              color: kTextColor,
              size: 50.0,
            )
          ],
        ),
      ),
    );
  }
}
