import 'dart:async';
import 'dart:ui';

import 'package:automatik_technician_app/authentication/login_screen.dart';
import 'package:flutter/material.dart';

import '../authentication/signup_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
    //send user to main screen
      Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
  });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/Logo.png"),
              const SizedBox(height: 15),
              const Text("Automatik Booking App",
              style: TextStyle(
                fontSize: 24, color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
