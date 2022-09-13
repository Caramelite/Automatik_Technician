import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/app_icon.dart';
import '../../Widgets/profile_widget.dart';
import '../../Widgets/small_text.dart';
import '../../services/auth_service.dart';
import '../../widgets/dimensions.dart';
import '../authentication/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedInUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final CollectionReference users =
  FirebaseFirestore.instance.collection('technicians');

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
          // print('this is:  ${loggedInUser!.email}');
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: Dimensions.height20+Dimensions.height30),
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('technicians').where('Email', isEqualTo: loggedInUser!.email).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(!snapshot.hasData) return const Text("Loading...");
                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot snap) {
                          return  Column(
                            children: [
                              CircleAvatar(
                                radius: 85,
                                backgroundColor: Colors.blue,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    snap['Image'],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ),
                              SizedBox(height: Dimensions.height20),
                              ProfileWidget(
                                  appIcon: const AppIcon(icon: Icons.person,
                                    backgroundColor: Colors.blue,
                                    iconColor: Colors.white,
                                    iconSize: 25,
                                    size: 40,
                                  ),
                                  smallText: SmallText(text: snap['Name'])
                              ),
                              SizedBox(height: Dimensions.height20),
                              //phone
                              ProfileWidget(
                                  appIcon: const AppIcon(icon: Icons.phone,
                                    backgroundColor: Colors.yellow,
                                    iconColor: Colors.white,
                                    iconSize: 25,
                                    size: 40,
                                  ),
                                  smallText: SmallText(text: snap['Phone'])
                              ),
                              SizedBox(height: Dimensions.height20),
                              //email
                              ProfileWidget(
                                  appIcon: const AppIcon(icon: Icons.email,
                                    backgroundColor: Colors.yellow,
                                    iconColor: Colors.white,
                                    iconSize: 25,
                                    size: 40,
                                  ),
                                  smallText: SmallText(text: snap['Email'])
                              ),
                              SizedBox(height: Dimensions.height20),
                              //address
                              ProfileWidget(
                                  appIcon: const AppIcon(icon: Icons.location_on,
                                    backgroundColor: Colors.yellow,
                                    iconColor: Colors.white,
                                    iconSize: 25,
                                    size: 40,
                                  ),
                                  smallText: SmallText(text: snap['Address'])
                              ),
                              SizedBox(height: Dimensions.height20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      _update(snap);
                                    },
                                    child: ProfileWidget(
                                        appIcon: const AppIcon(icon: Icons.edit,
                                          backgroundColor: Colors.redAccent,
                                          iconColor: Colors.white,
                                          iconSize: 25,
                                          size: 40,
                                        ),
                                        smallText: SmallText(text: "Update")
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      AuthController().signOut();
                                      Get.to(() => const LoginScreen());
                                    },
                                    child: ProfileWidget(
                                        appIcon: const AppIcon(icon: Icons.logout,
                                          backgroundColor: Colors.redAccent,
                                          iconColor: Colors.white,
                                          iconSize: 25,
                                          size: 40,
                                        ),
                                        smallText: SmallText(text: "Logout")
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }).toList(),
                      );
                    }
                ),
              ),
            ],
          )
      ),
    );
  }


  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['Name'];
      _phoneController.text = documentSnapshot['Phone'];
      _emailController.text = documentSnapshot['Email'];
      _addressController.text = documentSnapshot['Address'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                  ),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(

                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String phone = _phoneController.text;
                    final String email = _emailController.text;
                    final String address = _addressController.text;
                    if (name != null && phone != null && email != null && address != null) {
                      await users
                          .doc(documentSnapshot!.id)
                          .update({"Name": name, "Phone": phone, "Email": email, "Address": address});
                      _nameController.text = '';
                      _phoneController.text = '';
                      _emailController.text = '';
                      _addressController.text = '';
                    }
                  },
                )
              ],
            ),
          );
        }
    );
  }
}