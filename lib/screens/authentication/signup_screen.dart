import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../Widgets/dimensions.dart';
import '../../Widgets/rounded_buttons.dart';
import '../../Widgets/textfield.dart';
import '../../Widgets/validators.dart';
import '../../services/auth_service.dart';
import '../splashScreen/splash_screen.dart';
import 'login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showSpinner = false;
  late String email;
  late String password;
  TextEditingController emailT = TextEditingController();
  TextEditingController nameT = TextEditingController();
  TextEditingController addressT = TextEditingController();
  TextEditingController phoneT = TextEditingController();
  TextEditingController pass1T = TextEditingController();
  TextEditingController pass2T = TextEditingController();
  FocusNode emailFN = FocusNode();
  FocusNode nameFN = FocusNode();
  FocusNode addressFN = FocusNode();
  FocusNode phoneFN = FocusNode();
  FocusNode pass1FN = FocusNode();
  FocusNode pass2FN = FocusNode();
  bool hidePassword = true;
  bool hidePassword1 = true;

  ScrollController scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailT.dispose();
    nameT.dispose();
    addressT.dispose();
    phoneT.dispose();
    pass1T.dispose();
    pass2T.dispose();
    scrollController.dispose();

    super.dispose();
  }


  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  User? user = FirebaseAuth.instance.currentUser;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    const destination = 'Images/TechProfilePictures/';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(_photo!);

      //IMAGE URL
      imageUrl = await ref.getDownloadURL();
      await AuthController().signUpUser(nameT.text, addressT.text,
          emailT.text, pass2T.text, phoneT.text, imageUrl!);
      Get.to(() => const MySplashScreen());
    } catch (e) {
      print('error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height20*3),
            Center(
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color(0xffFDCF09),
                  child: _photo != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(
                      _photo!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                    width: 100,
                    height: 100,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20+Dimensions.height10),
            Container(
              margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: const Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2)
                    )
                  ]
              ),
              child: TextFormField(
                validator: UnifiedValidators.emptyValidator,
                controller: nameT,
                focusNode: nameFN,
                textAlign: TextAlign.left,
                onEditingComplete: () {
                  nameFN.requestFocus();
                },
                keyboardType: TextInputType.name,
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Name',
                  prefixIcon: const Icon(
                    Icons.person,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Container(
              margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: const Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2)
                    )
                  ]
              ),
              child: TextFormField(
                validator: UnifiedValidators.emptyValidator,
                controller: addressT,
                focusNode: addressFN,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.name,
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Address',
                  prefixIcon: const Icon(
                    Icons.location_on_rounded,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Container(
              margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: const Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2)
                    )
                  ]
              ),
              child: TextFormField(
                validator: UnifiedValidators.emailValidator,
                controller: emailT,
                focusNode: emailFN,
                textAlign: TextAlign.left,
                onEditingComplete: () {
                  phoneFN.requestFocus();
                },
                keyboardType: TextInputType.emailAddress,
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Email',
                  prefixIcon: const Icon(
                    Icons.email,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Container(
              margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: const Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2)
                    )
                  ]
              ),
              child: TextFormField(
                validator: UnifiedValidators.emptyValidator,
                controller: phoneT,
                focusNode: phoneFN,
                textAlign: TextAlign.left,
                onEditingComplete: () {
                  pass1FN.requestFocus();
                },
                keyboardType: TextInputType.number,
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(
                    Icons.phone,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Container(
              margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: const Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2)
                    )
                  ]
              ),
              child: TextFormField(
                validator: UnifiedValidators.passwordValidator,
                controller: pass1T,
                focusNode: pass1FN,
                textAlign: TextAlign.left,
                onEditingComplete: () {
                  pass2FN.requestFocus();
                },
                obscureText: hidePassword,
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(hidePassword
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Container(
              margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: const Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2)
                    )
                  ]
              ),
              child: TextFormField(
                validator: (value) =>
                    MatchValidator(errorText: 'Password does not match')
                        .validateMatch(pass1T.text, pass2T.text),
                controller: pass2T,
                focusNode: pass2FN,
                textAlign: TextAlign.left,
                obscureText: hidePassword1,
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(hidePassword1
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye),
                    onPressed: () {
                      setState(() {
                        hidePassword1 = !hidePassword1;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: RoundedButton(
                buttonTitle: 'Register',
                color: Colors.blueAccent,
                buttonOnPressed: () async {
                  uploadFile();
                 /* Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MySplashScreen()));
*/
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",  style: TextStyle(color: Colors.grey[700]),),
                TextButton(
                  child: Text("Login here",
                    style: TextStyle(color: Colors.grey[850]),
                  ),
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}