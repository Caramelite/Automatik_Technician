import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/pack.dart';

class AuthController {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> signUpUser(
      String name, String address, String email, String password, String phone, String image) async {
    String res = 'some error occurred';
    try {
      if (name.isNotEmpty &&
          address.isNotEmpty &&
          email.isNotEmpty &&
          phone.isNotEmpty &&
          image.isNotEmpty &&
          password.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        firebaseStore.collection('technicians').doc(cred.user!.uid).set({
          'Name': name,
          'Address': address,
          'Email': email,
          'Phone': phone,
          'ProfileImage': image,
        });
        print(cred.user!.email);
        res = 'success';
      } else {
        res = 'Fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Sign Out
  signOut() {
    return firebaseAuth.signOut();
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
}