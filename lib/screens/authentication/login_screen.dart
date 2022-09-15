import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/rounded_buttons.dart';
import '../../Widgets/textfield.dart';
import '../../Widgets/validators.dart';
import '../../services/auth_service.dart';
import '../mainScreens/main_screen.dart';
import 'signup_screen.dart';

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
                buttonOnPressed: () async {
                  final message = await AuthController().login(
                      email: emailTextEditingController.text,
                      password: passwordTextEditingController.text);
                  if(message!.contains('Success')) {
                    Get.to(() => const HomeScreen());
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account yet?",  style: TextStyle(color: Colors.grey[700]),),
                  TextButton(
                    child: Text("Click here",
                      style: TextStyle(color: Colors.grey[850]),
                    ),
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => const SignUpScreen()));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}