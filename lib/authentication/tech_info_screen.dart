import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';

class TechInfoScreen extends StatefulWidget
{
  const TechInfoScreen({Key? key}) : super(key: key);

  @override
  _TechInfoScreenState createState() => _TechInfoScreenState();
}

class _TechInfoScreenState extends State<TechInfoScreen> {
  TextEditingController idExpiryTextEditingController = TextEditingController();
  TextEditingController idNumberTextEditingController = TextEditingController();
  TextEditingController ratingTextEditingController = TextEditingController();

  List<String> specializationList = ["Engine repairs", "Brake and exhaust repairs", "Transmission repairs"];
  String? selectedSpecialization;


  saveTechInfo()
  {
    Map technicianInfoMap = {
      "id_expiry": idExpiryTextEditingController.text.trim(),
      "id_Number": idNumberTextEditingController.text.trim(),
      "rating": ratingTextEditingController.text.trim(),
      "specialization": selectedSpecialization,
    };

    DatabaseReference technicianRef = FirebaseDatabase.instance.ref().child("technician");
    technicianRef.child(currentFirebaseUser!.uid).child("technician_details").set(technicianInfoMap);

    Fluttertoast.showToast(msg: "Technician details has been saved.");
    Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/Logo.png"),
              ),
              const SizedBox(height: 10),
              const Text("Technician's Details",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
              ),
              TextField(
                  controller: idExpiryTextEditingController,
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                      labelText: "ID Expiry",
                      hintText: "ID Expiry",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14)
                  )
              ),
              TextField(
                  controller: idNumberTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                      labelText: "ID NUmber",
                      hintText: "ID Number",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14)
                  )
              ),
              TextField(
                  controller: ratingTextEditingController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                      labelText: "Rating",
                      hintText: "Rating",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14)
                  )
              ),
              const SizedBox(height: 10),
                DropdownButton(
                dropdownColor: Colors.black54,
                hint: const Text(
                  "Please choose your specialization",
                  style: TextStyle(fontSize: 14,
                  color: Colors.grey)
                ),
                value: selectedSpecialization,
                onChanged: (newValue){
                  setState(() {
                    selectedSpecialization = newValue.toString();
                  });
                },
                items: specializationList.map((special){
                  return DropdownMenuItem(
                      child: Text(special,
                          style: const TextStyle(color: Colors.grey)),
                    value: special,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: ()
                {
                  if(idExpiryTextEditingController.text.isNotEmpty
                      && idNumberTextEditingController.text.isNotEmpty
                      && ratingTextEditingController.text.isNotEmpty
                      && selectedSpecialization != null)
                  {
                    saveTechInfo();
                  }
                },
                style: ElevatedButton.styleFrom(primary: Colors.lightGreenAccent),
                child: const Text("Save",
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
