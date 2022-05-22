import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../assistants/assistant_methods.dart';
import '../global/global.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> 
{
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.271752, 123.850748),
    zoom: 14.4746,
  );

  Position? technicianCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  String statusText = "Go Online";
  Color buttonColor = Colors.grey;
  bool isTechnicianActive = false;

  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateCustomerPosition() async
  {
    //give us the position of the current user
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    technicianCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(technicianCurrentPosition!.latitude, technicianCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 16);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(technicianCurrentPosition!, context);
    print("This is your address = " + humanReadableAddress);

    // userName = customerModelCurrentInfo!.name!;
    // userEmail = customerModelCurrentInfo!.email!;
    //
    // print("name = " + userName);
    // print("email = " + userEmail);
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller)
          {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
          },
        ),

        //UI for online or offline technician
        statusText != "Go Offline"
            ? Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.black87,
        )
            : Container(),

        //Button for going online or offline
        Positioned(
            top: statusText  != "Go Offline" ? MediaQuery.of(context).size.height*0.46 : 25,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: ()
                {
                  if(isTechnicianActive != true) //offline
                  {
                    technicianOnlineNow();
                    updateTechnicianLocationAtRealTime();

                    setState(() {
                      statusText = "Go Offline";
                      isTechnicianActive = true;
                      buttonColor = Colors.transparent;
                    });

                    //display showToast
                    Fluttertoast.showToast(msg: "You are online now");
                  }
                  else
                    {
                      technicianIsOfflineNow();

                      setState(() {
                        statusText = "Go Online";
                        isTechnicianActive = false;
                        buttonColor = Colors.grey;
                      });

                      //display showToast
                      Fluttertoast.showToast(msg: "You are offline now");
                    }
                },
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape:RoundedRectangleBorder(borderRadius:  BorderRadius.circular(26))
                ),
                child: statusText != "Go Offline"
                    ? Text(statusText,
                style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white
                ))
                    : const Icon(
                  Icons.phonelink_ring,
                  color: Colors.white,
                  size: 26,
                ),

              )
            ],
          ),
        ),
      ],
    );
  }

  technicianOnlineNow() async
  {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    technicianCurrentPosition = pos;

     Geofire.initialize("activeTechnicians");
     Geofire.setLocation(
         currentFirebaseUser!.uid,
         technicianCurrentPosition!.latitude,
         technicianCurrentPosition!.longitude
     );
     DatabaseReference ref = FirebaseDatabase.instance.ref()
         .child("technician")
         .child(currentFirebaseUser!.uid)
         .child("newTechStatus");

     ref.set("idle"); //searching for customer's request
     ref.onValue.listen((event) { });
  }

  updateTechnicianLocationAtRealTime()
  {
    streamSubscriptionPosition = Geolocator.getPositionStream()
        .listen((Position position) 
    {
      technicianCurrentPosition = position;
      if(isTechnicianActive == true)
      {
        Geofire.setLocation(
            currentFirebaseUser!.uid,
            technicianCurrentPosition!.latitude,
            technicianCurrentPosition!.longitude
        );
      }

      LatLng latLng = LatLng(
        technicianCurrentPosition!.latitude,
        technicianCurrentPosition!.longitude
      );

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  technicianIsOfflineNow()
  {
    Geofire.removeLocation(currentFirebaseUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref()
        .child("technician")
        .child(currentFirebaseUser!.uid)
        .child("newTechStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 2000), ()
    {
      //Minimize the app when the technician goes offline
      SystemChannels.platform.invokeListMethod("SystemNavigator.pop");
    });
  }
}
