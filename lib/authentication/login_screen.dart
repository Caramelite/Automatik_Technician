

import 'package:automatik_technician_app/Widgets/rounded_buttons.dart';
import 'package:automatik_technician_app/Widgets/textfield.dart';
import 'package:automatik_technician_app/Widgets/validators.dart';
import 'package:automatik_technician_app/authentication/signup_screen.dart';
import 'package:automatik_technician_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  FocusNode emailFN = FocusNode();
  FocusNode passwordFN = FocusNode();
  bool hidePassword = true;

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("assets/images/Logo.png"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: UnifiedValidators.emailValidator,
                controller: emailTextEditingController,
                focusNode: emailFN,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.start,
                onEditingComplete: () {
                  passwordFN.requestFocus();
                },
                style: const TextStyle(color: Colors.blueAccent),
                decoration: kTextFieldDecoration.copyWith(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: UnifiedValidators.passwordValidator,
                controller: passwordTextEditingController,
                focusNode: passwordFN,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                obscureText: hidePassword,
                onEditingComplete: () {
                  passwordFN.unfocus();
                },
                style: const TextStyle(color: Colors.blueAccent),
                decoration: kTextFieldDecoration.copyWith(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20.0),
              RoundedButton(
                color: Colors.lightBlueAccent,
                buttonTitle: 'LOGIN',
                buttonOnPressed: () async{
               await AuthController().signInUser(emailTextEditingController.text, passwordTextEditingController.text);
               
                },
              ),
              TextButton(
                child: const Text(
                  "Don't have an account yet? Click here",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const SignUpScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
