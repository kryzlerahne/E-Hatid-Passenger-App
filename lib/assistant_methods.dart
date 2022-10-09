import 'package:ehatid_passenger_app/request_assistant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class AssistantMethods
{

  static Future<String> searchAddressForGeographicCoordinates(Position position) async
  {
    String mapKey = "";
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occured, Failed. No response.")
    {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];
    }
    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async
  {

    final FirebaseAuth fAuth = FirebaseAuth.instance;
    User? currentFirebaseUser;
    UserModel? userModelCurrentInfo;

    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }
}

class UserModel
{
  String? phone;
  String? name;
  String? id;
  String? email;

  UserModel({this.phone, this.name, this.id, this.email,});

  UserModel.fromSnapshot(DataSnapshot snap)
  {
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
  }
}