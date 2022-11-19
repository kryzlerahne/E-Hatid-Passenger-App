import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ehatid_passenger_app/driver_request_information.dart';
import 'package:ehatid_passenger_app/notification_dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'global.dart';

class PushNotificationSystem
{
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async
  {
    //1. Terminated
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage)
    {
      if(remoteMessage != null)
      {

        //display ride request information
        readUserRideRequestInformation(remoteMessage.data["rideRequestId"], context);
      }
    });

    //2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage)
    {

      //display ride request information
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);
    });

    //3. Background
    //When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage)
    {

      //display ride request information
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);
    });
  }

  readUserRideRequestInformation(String userRideRequestId, BuildContext context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .child(userRideRequestId)
        .once()
        .then((snapData)
    {
      if(snapData.snapshot.value != null)
      {
        // audioPlayer.open(Audio("assets/music/boom_tarat_tarat.mp3"));
        // audioPlayer.play();

        // double originLat = double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"]);
        // double originLng = double.parse((snapData.snapshot.value! as Map)["origin"]["longitude"]);
        // String originAddress = (snapData.snapshot.value! as Map)["originAddress"];
        //
        // double destinationLat = double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"]);
        // double destinationLng = double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"]);
        // String destinationAddress = (snapData.snapshot.value! as Map)["destinationAddress"];

        String driverName = (snapData.snapshot.value! as Map)["driverName"];
        //String driverPhone = (snapData.snapshot.value! as Map)["phone"];
        String plateNum = (snapData.snapshot.value! as Map)["driverPlateNum"];
        //String ratings = (snapData.snapshot.value! as Map)["ratings"];
        //String userPhone = (snapData.snapshot.value! as Map)["userPhone"];


        String? rideRequestId = snapData.snapshot.key;

        DriverRequestInformation driverRideRequestDetails = DriverRequestInformation();

        driverRideRequestDetails.driverName = driverName;
        //userRideRequestDetails.userPhone = userPhone;
        driverRideRequestDetails.plateNum = plateNum;

        showDialog(
          context: context,
          builder: (BuildContext context) => NotificationDialogBox(
            driverRideRequestDetails: driverRideRequestDetails,
          ),
        );
      }
      else
      {
        Fluttertoast.showToast(msg: "This Ride Request Id do not exist.");
      }
    });

  }

  Future generateAndGetToken() async
  {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: ");
    print(registrationToken);

    FirebaseDatabase.instance.ref()
        .child("passengers")
        .child(currentFirebaseUser.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}