import 'package:firebase_database/firebase_database.dart';

class TechnicianModel
{
  String? phone;
  String? name;
  String? id;
  String? email;
  String? imagePath;

  TechnicianModel({this.phone, this.name, this.email, this.id});

  TechnicianModel.fromSnapshot(DataSnapshot snap)
  {
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
    imagePath = (snap.value as dynamic)["imagePath"];
  }
}