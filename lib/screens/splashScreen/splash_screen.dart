import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/global.dart';
import '../authentication/login_screen.dart';
import '../mainScreens/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {


  startTimer() {
    //fAuth.currentUser != null ? AssistantMethods.readCurrentOnLineUserInfo() : null;

    Timer(const Duration(seconds: 2), () async {
      if(await fAuth.currentUser != null)
      {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      }
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
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/Logo.png"),
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