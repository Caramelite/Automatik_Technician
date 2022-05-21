import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistants/assistant_methods.dart';

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

  Position? customerCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

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
    customerCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(customerCurrentPosition!.latitude, customerCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 16);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(customerCurrentPosition!, context);
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
        )
      ],
    );
  }
}
