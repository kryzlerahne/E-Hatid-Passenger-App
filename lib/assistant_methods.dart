import 'dart:convert';

import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/direction_details_info.dart';
import 'package:ehatid_passenger_app/directions.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/request_assistant.dart';
import 'package:ehatid_passenger_app/trips_history_model.dart';
import 'package:ehatid_passenger_app/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AssistantMethods
{

  static Future<String> searchAddressForGeographicCoordinates(Position position, context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error occurred, Failed. No response")
    {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    String userCurrentLocation = humanReadableAddress;
    print("Eto oh" + userCurrentLocation);
    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async
  {

    final FirebaseAuth fAuth = FirebaseAuth.instance;
    User? currentFirebaseUser;

    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("passengers")
        .child(currentFirebaseUser!.uid);

    userRef.onValue.listen((snap)
    {
      if(snap.snapshot.value != null)
      {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
        print("name" + userModelCurrentInfo!.first_name.toString());
        print("username" + userModelCurrentInfo!.username.toString());
      }
    });

  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionApi == "Error occurred, Failed. No response")
      {
        return null;
      }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {
    double timeTraveledFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.1; //Per minute magkano ang ichacharge mo

    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.distance_value! / 2000) * 50;

    if(directionDetailsInfo.distance_value! > 3000)
    {
      double totalFareAmount = 50;
      return double.parse(totalFareAmount.toStringAsFixed(1));
    }
    else
      {
        double totalFareAmount = 40;
        return double.parse(totalFareAmount.toStringAsFixed(2));
      }

    //Round off

    //If 1 USD = 58 peso
   // double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;
   // double localCurrencyTotalFare = totalFareAmount * 58; for conversion
  }

  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async
  {
    String destinationAddress = userDropOffAddress;

    Map<String, String> headerNotification =
    {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification =
    {
      "body":"Destination Address: \n $destinationAddress.",
      "title":"New Trip Request"
    };

    Map dataMap =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat =
    {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }


  //retrieve the trips key for online user
  //trip key = ride request key


  static void readTripKeysForOnlineUser(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .orderByChild("username")
        .equalTo(userModelCurrentInfo!.username)
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null) {
        Map keysTripsId = snap.snapshot.value as Map;

        //count total number of trips and share it with provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsCounter(
            overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripKeysList = [];
        keysTripsId.forEach((key, value) {
          tripKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsKeys(tripKeysList);

        // Get the trips keys data - read the trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context)
  {
    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for(String eachKey in tripsAllKeys)
    {
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachKey)
          .orderByChild("time")
          .limitToFirst(20)
          .once()
          .then((snap)

      {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended")
        {
          //update or add each history to OverAllTrips History Data List
          Provider.of<AppInfo>(context, listen: false).updateOverAllTripsHistoryInformation(eachTripHistory);
        }

      });
    }
  }

  static void readLifePoints(context)
  {
    FirebaseDatabase.instance.ref()
        .child("passengers")
        .child(fAuth.currentUser!.uid)
        .child("lifePoints")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        String passengerLife = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateLifePoints(passengerLife);
      }
    });
  }

  static void readRatings(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .child(driverId)
        .child("ratings")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        String rating = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateRatings(rating);
      }
    });
  }
}

