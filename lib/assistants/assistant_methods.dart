import 'package:automatik_technician_app/assistants/request_assistant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../models/directions.dart';
import '../models/user_model.dart';

class AssistantMethods
{
  static Future<String> searchAddressForGeographicCoordinates(Position position, context ) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receivedRequest(apiUrl);
    if(requestResponse != "Error Occurred. Failed, no response.")
    {
      // if (requestResponse != null && requestResponse.length != 0){
      //   humanReadableAddress = requestResponse["results"][0]["formatted_address"];
      // }

      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions customerCurrentAddress = Directions();
      customerCurrentAddress.locationLatitude = position.latitude;
      customerCurrentAddress.locationLongitude = position.longitude;
      customerCurrentAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updateCurentLocationAddress(customerCurrentAddress);
    }
    return humanReadableAddress;
  }

  static void readCurrentOnLineUserInfo() async
  {
    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference customerRef = FirebaseDatabase.instance.ref()
        .child("customer").child(currentFirebaseUser!.uid);

    customerRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        technicianModelCurrentInfo = TechnicianModel.fromSnapshot(snap.snapshot);
      }
    });
  }
}