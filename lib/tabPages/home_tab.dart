import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Widgets/dimensions.dart';
import '../Widgets/textfield.dart';
import '../Widgets/validators.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.296838615231485, 123.87087173762541),
    zoom: 15.80,
  );
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newGoogleMapController;
  Position? position;
  List<Placemark>? placemarks;
  TextEditingController locationT = TextEditingController();

  getCurrentLocation() async{
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placemarks = await placemarkFromCoordinates(
      position!.latitude, position!.longitude
    );

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Placemark pMark = placemarks![0];
    String completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationT.text = completeAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;
            },
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
                padding: EdgeInsets.only(bottom: Dimensions.height20*3.2, left: Dimensions.width20, right: Dimensions.width20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                          color: Colors.grey.withOpacity(0.2)
                      )
                    ]
                ),
                child: TextFormField(
                  validator: UnifiedValidators.emptyValidator,
                  controller: locationT,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.name,
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Location',
                    /*prefixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),*/
                  ),
                )
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: ElevatedButton(
              child: const Text(
                'Get Location'
              ),
              onPressed: () {
                getCurrentLocation();
                }
            ),
          )
        ],
      );
  }
}
