import 'package:flutter/cupertino.dart';
import '../models/directions.dart';

class AppInfo extends ChangeNotifier
{
  Directions? customerCurrentLocation;


  void updateCurentLocationAddress(Directions customerCurrentAddress)
  {
    customerCurrentLocation = customerCurrentAddress;
    notifyListeners();
  }
}