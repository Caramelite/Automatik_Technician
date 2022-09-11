
import 'package:automatik_technician_app/constants/pack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthController {
  Future<User?> signInUser(
    String email, String password) async {
    String res = 'some error occured';
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        UserCredential cred = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      }
    }catch (e){
      res = e.toString();
    }
    return null;
  }
  Future<User?> signUpUser(
      String firstname, String lastname, String email, String password) async {
    String res = 'some error occured';
    try {
      if (firstname.isNotEmpty &&
          lastname.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        firebaseStore.collection('technicians').doc(cred.user!.uid).set({
          'First Name': firstname,
          'Last Name': lastname,
          'Email': email,
        });
        print(cred.user!.email);
        res = 'success';
      } else {
        res = 'Fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return null;
  }
  
}
