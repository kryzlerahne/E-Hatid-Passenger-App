import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:ehatid_passenger_app/Account/account.dart';
import 'package:ehatid_passenger_app/AssignedDriverWidget.dart';
import 'package:ehatid_passenger_app/about_screen.dart';
import 'package:ehatid_passenger_app/accept_decline.dart';
import 'package:ehatid_passenger_app/active_nearby_available_drivers.dart';
import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/cancellation.dart';
import 'package:ehatid_passenger_app/geofire_assistant.dart';
import 'package:ehatid_passenger_app/long_waiting_UI.dart';
import 'package:ehatid_passenger_app/main.dart';
import 'package:ehatid_passenger_app/pay_fare_amount_dialog.dart';
import 'package:ehatid_passenger_app/processing_dialog.dart';
import 'package:ehatid_passenger_app/profile_screen.dart';
import 'package:ehatid_passenger_app/push_notification_system.dart';
import 'package:ehatid_passenger_app/rate_driver_screen.dart';
import 'package:ehatid_passenger_app/search_places_screen.dart';
import 'package:ehatid_passenger_app/select_nearest_active_driver_screen.dart';
import 'package:ehatid_passenger_app/showAmountDialog.dart';
import 'package:ehatid_passenger_app/tripInvoice.dart';
import 'package:ehatid_passenger_app/trips_history_screen.dart';
import 'package:ehatid_passenger_app/user_model.dart';
import 'package:ehatid_passenger_app/view_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercharged/supercharged.dart';
import 'Screens/Login/sign_in.dart';
import 'assistant_methods.dart';
import 'global.dart';

class MapSample extends StatefulWidget {

  @override
  State<MapSample> createState() => MapSampleState();

  String? name;
  String? email;

  MapSample({this.name, this.email});
}

class MapSampleState extends State<MapSample> {

  late bool _isLoading;
  TextEditingController _destinationController = TextEditingController();

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  bool isVisible = true;
  bool notified = false;

  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //UserModel? userModelCurrentInfo;

  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      await _firebaseAuth.signOut();
      Navigator.of(context, rootNavigator:
      true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          SignIn()), (route) => false);
    } catch (e) {
      print(e.toString()) ;
    }
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.7731, 121.0484),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String name = "Loading...";
  String userName = " ";
  String userId = "";
  String userEmail = "Email";

  bool activeNearbyDriverKeysLoaded = false; //Active drivers code

  List<ActiveNearbyAvailableDrivers> onlineNearbyAvailableDriversList = []; //Ride Request Code

  //DirectionDetailsInfo? tripDirectionDetailsInfo;

  DatabaseReference? referenceRideRequest;
  String driverRideStatus = "Your driver is coming.";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  String userRideRequestStatus="";
  bool requestPositionInfo = true;


  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(userCurrentPosition!, context);
    print("this is your address =" + humanReadableAddress);

    //initializeGeoFireListener(); //Active Drivers

    AssistantMethods.readTripKeysForOnlineUser(context);
    AssistantMethods.readLifePoints(context);
    AssistantMethods.readRatings(context);
  }

  readCurrentPassengerInformation() async
  {
    currentFirebaseUser = fAuth.currentUser;
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading=false;
      });
    });

    super.initState();
    //_setMarker(LatLng(37.42796133580664, -122.085749655962));
    AssistantMethods.readCurrentOnlineUserInfo();
    checkIfLocationPermissionAllowed();

    //AssistantMethods.readCurrentOnlineUserInfo();
    readCurrentPassengerInformation();
  }

  passengerIsOnlineNow() async
  {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    userCurrentPosition = pos;

    Geofire.initialize("activePassengers");

    Geofire.setLocation(
        user.uid,
        userCurrentPosition!.latitude,
        userCurrentPosition!.longitude
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref()
        .child("passengers")
        .child(user.uid)
        .child("newRideStatus");

    ref.set(""); //searching for ride request
    ref.onValue.listen((event) { });
  }

  updatePassengersLocationAtRealTime()
  {
    streamSubscriptionPosition = Geolocator.getPositionStream()
        .listen((Position position)
    {
      userCurrentPosition = position;

      Geofire.setLocation(
          user.uid,
          userCurrentPosition!.latitude,
          userCurrentPosition!.longitude
      );

      LatLng latLng = LatLng(
        userCurrentPosition!.latitude,
        userCurrentPosition!.longitude,
      );

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  saveRideRequestInformation() //Ride Request Code
  {
    //1. save the Ride Request Information

    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Requests").push(); // Creates unique ID
    String? rideKey = referenceRideRequest!.key.toString();

    var originLocation = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap =
    {
      //key:value
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation!.locationLongitude.toString(),
    };

    Map destinationLocationMap =
    {
      //key:value
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation!.locationLongitude.toString(),
    };

    Map userInformationMap =
    {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "name": userModelCurrentInfo!.first_name.toString() + " " + userModelCurrentInfo!.last_name.toString(),
      "username": userModelCurrentInfo!.username!,
      "email": userModelCurrentInfo!.email!,
      "id": userModelCurrentInfo!.id!,
      "requestId": rideKey,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
      "notified" : "false",
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription = referenceRideRequest!.onValue.listen((eventSnap) async // getting updates in real time
        {
      if(eventSnap.snapshot.value == null)
      {
        return;
      }

      if ((eventSnap.snapshot.value as Map)["originAddress"] != null) //!! GAWING CAR DETAILS/ PLATE NUMBER
          {
        setState(() {
          userCurrentLocation = (eventSnap.snapshot.value as Map)["originAddress"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverPlateNum"] != null) //!! GAWING CAR DETAILS/ PLATE NUMBER
          {
        setState(() {
          driverTricDetails = (eventSnap.snapshot.value as Map)["driverPlateNum"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["requestId"] != null) //!! GAWING CAR DETAILS/ PLATE NUMBER
          {
        setState(() {
          rideRequestId = (eventSnap.snapshot.value as Map)["requestId"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) //!! GET PHONE NUMBER
          {
        setState(() {
          driverPhone = (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) //!! GET PHONE NUMBER
          {
        setState(() {
          fareAmount = (eventSnap.snapshot.value as Map)["fareAmount"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverName"] != null) //!! GET FNAME
          {
        setState(() {
          driverName = (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["requestId"] != null) //!! GET FNAME
          {
        setState(() {
          requestId = (eventSnap.snapshot.value as Map)["requestId"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverRatings"] != null) //!! GET FNAME
          {
        setState(() {
          rateDriver = (eventSnap.snapshot.value as Map)["driverRatings"].toString();
          ratingDriver = rateDriver.toDouble()!;
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverId"] != null) //!! GET FNAME
          {
        setState(() {
          driverId = (eventSnap.snapshot.value as Map)["driverId"].toString();

          // if(driverId != null)
          // {
          //   if(driverId == "waiting")
          //   {
          //     showWaitingResponseFromDriverUI();
          //     timerDialog();
          //   } else {
          //     showUIForAssignedDriverInfo();
          //   }
          // }

        });
      }

      if((eventSnap.snapshot.value as Map)["status"] != null)
      {
        setState(() {
          userRideRequestStatus = (eventSnap.snapshot.value as Map)["status"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["driverLocation"] != null)
      {
        double driverCurrentPositionLat = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
        double driverCurrentPositionLng = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());

        LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        if(userRideRequestStatus != null)
        {
          isVisible= !isVisible;
          showUIForAssignedDriverInfo();

          //when status = accepted
          if(userRideRequestStatus == "accepted") {
            if (notified==false)
            {
              passengerIsOfflineNow();
              assignedDriverModal();
              updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
              notified = true;
            }
          }

          //when status = arrived
          if(userRideRequestStatus == "arrived")
          {
            setState(() {
              driverRideStatus = "Your driver has arrived.";
            });
          }

          //when status = onTrip
          if(userRideRequestStatus == "onTrip")
          {
            updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
          }

          //when status = ended
          if(userRideRequestStatus == "ended")
          {
            if((eventSnap.snapshot.value as Map)["fareAmount"] != null)
            {
              double fareAmount = double.parse((eventSnap.snapshot.value as Map)["fareAmount"].toString());

              var response = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext c) => PayFareAmountDialog(
                  fareAmount: fareAmount,
                ),
              );

              if(response == "cashPayed")
              {
                //user can rate the driver
                if((eventSnap.snapshot.value as Map)["driverId"] != null)
                {
                  String assignedDriverId = (eventSnap.snapshot.value as Map)["driverId"].toString();

                  Navigator.push(context, MaterialPageRoute(builder: (c)=> RateDriverScreen(
                    assignedDriverId: assignedDriverId,
                  )));

                  referenceRideRequest!.onDisconnect();
                  tripRideRequestInfoStreamSubscription!.cancel();
                }
              }
            }
          }
        }
      }
    });

    onlineNearbyAvailableDriversList = GeoFireAssistant.activeNearbyAvailableDriversList;
    //searchNearestOnlineDrivers();
  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo = true)
    {
      requestPositionInfo = false;

      LatLng userPickupPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userPickupPosition,
      );

      if(directionDetailsInfo == null)
      {
        return;
      }

      setState(() {
        driverRideStatus = "Your driver is coming: " + directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo = true)
    {
      requestPositionInfo = false;

      var dropOffLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
      LatLng userDestinationPosition = LatLng(
          dropOffLocation!.locationLatitude!,
          dropOffLocation!.locationLongitude!
      );

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userDestinationPosition,
      );

      if(directionDetailsInfo == null)
      {
        return;
      }

      setState(() {
        driverRideStatus = "Going towards your destination: " + directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  showUIForAssignedDriverInfo()
  {
    setState(() {
      // showWaitingResponseFromDriverUI();
      isVisible = !isVisible;
      waitingResponseFromDriverContainerHeight = 0;
      assignedDriverInfoContainerHeight = Adaptive.h(30);
    });
  }

  showDialogForLongWaiting()
  {
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      assignedDriverInfoContainerHeight = 0;
      isVisible = true;

      showDialog(
        context: context,
        builder: (context) => LongWaitUI(),
      );
      //remove ride request in dbase
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(referenceRideRequest!.key.toString())
          .remove();
      passengerIsOfflineNow();
      // RestartWidget.restartApp(context);
    });
  }

  timerDialog()
  {
    Timer(Duration(seconds: 500), () {
      showDialogForLongWaiting();
    });
  }

  showWaitingResponseFromDriverUI()
  {
    setState(() {
      isVisible = !isVisible;
      waitingResponseFromDriverContainerHeight = Adaptive.h(33);

      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return ProcessingBookingDialog(message: "Please wait..",);
          }); // showdialog
    });
  }

  sendNotificationToDriverNow(String chosenDriverId)
  {
    //assign RideRequestId to newRideStatus in Drives Parent node for that specific chosen driver
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId!)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    //automate the push notifications
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId!)
        .child("token")
        .once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //send notification now
        AssistantMethods.sendNotificationToDriverNow(
          deviceRegistrationToken,
          referenceRideRequest!.key.toString(),
          context,
        );

        Fluttertoast.showToast(msg: "Notification sent successfully.");
      }
      else
      {
        Fluttertoast.showToast(msg: "Please choose another driver.");
        return;
      }
    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async
  {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for(int i = 0; i<onlineNearestDriversList.length; i++)
    {
      await ref.child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot)
      {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
        print("driverKey Info: " + dList.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      backgroundColor: Color(0xFFEBE5D8),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text('E-Hatid',
            style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFFFED90F),
                    ),
                    accountName: // new Text(widget.name.toString())
                    new Text(name,
                      style: TextStyle( color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,),
                    ),// added null condition here,
                    accountEmail: user.email! !=null ? new Text(user.email!,
                      style: TextStyle( color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,),
                    ): new Text(""),
                    currentAccountPicture: new CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage:  AssetImage("assets/images/icon.png"),
                    ),
                  ),
                  ListTile(
                    title: new Text("Home",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xFFFED90F), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: (){
                      Navigator.pushAndRemoveUntil<dynamic>(context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => MapSample(),
                        ), (route) => false,//if you want to disable back feature set to false
                      );
                      if(referenceRideRequest!.key != null)
                      {
                        FirebaseDatabase.instance.ref()
                            .child("All Ride Requests")
                            .child(referenceRideRequest!.key.toString())
                            .remove();
                      }
                      passengerIsOfflineNow();
                    },
                    leading: Icon(
                      Icons.home,
                      color: Color(0xFFFED90F),
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Color(0xFFFED90F),
                    ),
                  ),
                  ListTile(
                    title: new Text("Visit Profile",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: (){
                      Navigator.pushAndRemoveUntil<dynamic>(context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => ViewProfile(),
                        ), (route) => false,//if you want to disable back feature set to false
                      );
                      if(referenceRideRequest!.key != null)
                      {
                        FirebaseDatabase.instance.ref()
                            .child("All Ride Requests")
                            .child(referenceRideRequest!.key.toString())
                            .remove();

                        passengerIsOfflineNow();
                      }
                    },
                    leading: Icon(
                      Icons.account_circle_sharp,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                  ListTile(
                    title: new Text("History",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: (){
                      Navigator.pushAndRemoveUntil<dynamic>(context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => TripsHistoryScreen(),
                        ), (route) => false,//if you want to disable back feature set to false
                      );
                      if(referenceRideRequest!.key != null)
                      {
                        FirebaseDatabase.instance.ref()
                            .child("All Ride Requests")
                            .child(referenceRideRequest!.key.toString())
                            .remove();

                        passengerIsOfflineNow();
                      }
                    },
                    leading: Icon(
                      Icons.question_answer_outlined,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                  ListTile(
                    title: new Text("FAQ",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: ()
                    {
                      Navigator.pushAndRemoveUntil<dynamic>(context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => FAQScreen(),
                        ), (route) => false,//if you want to disable back feature set to false
                      );
                      if(referenceRideRequest!.key != null)
                      {
                        FirebaseDatabase.instance.ref()
                            .child("All Ride Requests")
                            .child(referenceRideRequest!.key.toString())
                            .remove();

                        passengerIsOfflineNow();
                      }
                    },
                    leading: Icon(
                      Icons.info_outline_rounded,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            ListTile(
                              title: Text("Sign Out",
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w400
                                ),
                              ),
                              onTap: () async => await _signOut(),
                              leading: Icon(
                                Icons.logout,
                              ),
                              trailing: Icon(
                                Icons.arrow_right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget> [ Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: _kGooglePlex,
                polylines: polyLineSet,
                markers: markersSet,
                // circles: circlesSet,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController = controller;

                  readLifePoints();

                  name = userModelCurrentInfo!.first_name! + " " + userModelCurrentInfo!.last_name!;
                  userName = userModelCurrentInfo!.username!;
                  userId = userModelCurrentInfo!.id!;
                  userEmail = userModelCurrentInfo!.email!;
                  locateUserPosition();
                },
              ),
            ),
            if (isVisible)
              Column(
                children: [
                  Container(
                    width: Adaptive.w(100),
                    decoration: BoxDecoration(
                      color: Color(0xFFFED90F),
                      //borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Hello " + userName,
                        //userModelCurrentInfo!.username! != null ? "Hello " + userModelCurrentInfo!.username! + "!" : "Hello!",
                        //AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!).toString(),
                        //tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.distance_text! : "",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 18.sp,
                            letterSpacing: -1,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: Adaptive.h(1.5),),
                  Text("Where are you heading to?",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 19.sp,
                        letterSpacing: -1,
                        fontWeight: FontWeight.bold),
                    //textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Adaptive.h(1.5),),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: <Widget> [
                            TextFormField(
                              readOnly: true,
                              //controller: _originController,
                              //textCapitalization: TextCapitalization.words,
                              enabled: false,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFFED90F),),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: Provider.of<AppInfo>(context).userPickUpLocation != null
                                      ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!
                                      : "Current location",
                                  hintStyle: TextStyle( color: Color(0xbc000000),
                                    fontSize: 15,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w400,),
                                  fillColor: Colors.white,
                                  filled: true,
                                  suffixIcon: Icon(Icons.location_pin,  color: Color(0xffCCCCCC))
                              ),
                            ),
                            SizedBox(height: Adaptive.h(1.5),),
                            TextFormField(
                              controller: _destinationController,
                              //textCapitalization: TextCapitalization.words,
                              readOnly: true,
                              onTap: () async
                              {
                                var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchPlacesScreen()));

                                if(responseFromSearchScreen == "Obtained Destination Address")
                                {
                                  //Draw Routes and polyline
                                  await drawPolyLineFromSourceToDestination();
                                }
                              },
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFFED90F),),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText:  Provider.of<AppInfo>(context).userDropOffLocation != null
                                      ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                      : "Destination",
                                  hintStyle: TextStyle( color: Color(0xbc000000),
                                    fontSize: 15,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w400,),
                                  fillColor: Colors.white,
                                  filled: true,
                                  suffixIcon: Icon(Icons.storefront,  color: Color(0xffCCCCCC))
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Adaptive.h(1.5),),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    minWidth: Adaptive.w(40),
                    child: Text("Request a Ride", style: TextStyle( color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,),),
                    color: Color(0XFF0CBC8B),
                    onPressed: ()
                    {

                      getFareAmount();

                      Timer(Duration(milliseconds: 400), () async {
                        var response = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext c) => ShowAmount()
                        );

                        if (response=="AgreedFareAmount")
                        {
                          if(Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null)
                          {
                            passengerIsOnlineNow();
                            saveRideRequestInformation();
                            showWaitingResponseFromDriverUI();
                          }
                          else
                          {
                            Fluttertoast.showToast(msg: "Please select your destination location first.");
                          }
                        }
                      });
                    },
                  ),
                  SizedBox(height: Adaptive.h(1.5),),
                ],
              ),

            //ui for waiting response from the driver
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: 100.w,
                height: waitingResponseFromDriverContainerHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFFFED90F),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text("We are processing your booking...",
                        style: TextStyle( color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,),
                      ),
                    ),
                    Text("Please wait while we connect you to your driver.",
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: Adaptive.h(2),),
                    FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                        children: [
                          SizedBox(width: Adaptive.w(2),),
                          Image.asset("assets/images/line.png", height: Adaptive.h(14),),
                          SizedBox(width: Adaptive.w(5),),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_pin, size: 15, color:  Color(0XFF9E9E9E),),
                                  Text("Pickup Point:",
                                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600,color: Color(0XFF9E9E9E)),),
                                ],
                              ),
                              Container(
                                width: Adaptive.w(70),
                                child: Text(userCurrentLocation,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Montserrat',),),
                              ), //PLACE YOUR LOCATION HERE
                              SizedBox(height: Adaptive.h(2),),
                              Center(
                                child: Container(
                                  width: 280,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                              ),
                              SizedBox(height: Adaptive.h(1),),
                              Row(
                                children: [
                                  Icon(Icons.storefront, size: 15, color: Color(0XFFFFBA4C),),
                                  SizedBox(width: Adaptive.w(1),),
                                  Text("Destination:",
                                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, color: Color(0XFFFFBA4C)),),
                                ],
                              ),
                              Container(
                                width: Adaptive.w(70),
                                child: Text(userDropOffAddress.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Montserrat',),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Adaptive.h(1),),
                    MaterialButton(
                      onPressed: (){
                        showDialogForLongWaiting();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      minWidth: Adaptive.w(30),
                      child: Text("Cancel Waiting", style: TextStyle( color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,),),
                      color: Color(0XFFE74338),
                    ),
                  ],
                ),

              ),
            ),

            //ui for displaying assigned driver info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: assignedDriverInfoContainerHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFFFED90F),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          SizedBox(width: Adaptive.w(2),),
                          // SizedBox(width: Adaptive.w(2),),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.person_pin,
                                    size: 20,
                                    color: Color(0xFF272727),
                                  ),SizedBox(width: Adaptive.w(2),),
                                  Text(driverName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.7.w, fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Tricycle Plate Number: " + driverTricDetails,
                                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 3.6.w,
                                    ),
                                  ),
                                  Text( driverPhone + " | Php " + fareAmount,
                                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 3.6.w,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                      SizedBox(
                        height: Adaptive.h(2),
                      ),
                      Center(
                        child: Container(
                          width:Adaptive.w(90),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.0),
                            child: Center(
                              child: Text(driverRideStatus,
                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.3.w, fontWeight: FontWeight.w600,color: Color(0XFF0CBC8B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Adaptive.h(1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context) => tripInvoice(),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            minWidth: Adaptive.w(37),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                Text("View Trip Invoice",
                                  style: TextStyle( color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,),),
                              ],
                            ),
                            color: Color(0XFF0CBC8B),
                          ),
                          SizedBox(
                            width: Adaptive.w(2),
                          ),
                          MaterialButton(
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context) => cancelDialog(),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            minWidth: Adaptive.w(40),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                Text("Cancel Trip",
                                  style: TextStyle( color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,),),
                              ],
                            ),
                            color: Color(0XFFE74338),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        ],
      ),
    );
  }

  Future<void> drawPolyLineFromSourceToDestination() async
  {
    var sourcePosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var sourceLatLng = LatLng(sourcePosition!.locationLatitude!, sourcePosition!.locationLongitude!);
    destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition!.locationLongitude!);

    computeFareAmount();

    BookingSuccessDialog();

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(sourceLatLng, destinationLatLng!);

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    //Navigator.of(context, rootNavigator: true).pop(context);

    print("These are points: ");
    print(directionDetailsInfo!.e_points!);

    //Decoding of points

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoOrdinatesList.clear();

    if(decodedPolyLinePointsResultList.isNotEmpty)
    {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng)
      {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Color(0XFF0CBC8B),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 3,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if(sourceLatLng.latitude > destinationLatLng!.latitude && sourceLatLng.longitude > destinationLatLng!.longitude)
    {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng!, northeast: sourceLatLng);
    }
    else if(sourceLatLng.longitude > destinationLatLng!.longitude)
    {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(sourceLatLng.latitude, destinationLatLng!.longitude),
        northeast: LatLng(destinationLatLng!.latitude, sourceLatLng.longitude),
      );
    }
    else if(sourceLatLng.latitude > destinationLatLng!.latitude)
    {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng!.latitude, sourceLatLng.longitude),
        northeast: LatLng(sourceLatLng.latitude, destinationLatLng!.longitude),
      );
    }
    else
    {
      boundsLatLng = LatLngBounds(southwest: sourceLatLng, northeast: destinationLatLng!);
    }

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    setState(() async {
      BitmapDescriptor originIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/originMarker.png",
      );

      BitmapDescriptor destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/destinationMarker.png",
      );

      Marker originMarker = Marker(
        markerId: const MarkerId("originID"),
        infoWindow: InfoWindow(title: sourcePosition.locationName, snippet: "Origin"),
        position: sourceLatLng,
        icon: originIcon,
      );

      Marker destinationMarker = Marker(
        markerId: const MarkerId("destinationID"),
        infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
        position: destinationLatLng!,
        icon: destinationIcon,
      );

      setState(() {
        markersSet.add(originMarker);
        markersSet.add(destinationMarker);
      });
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: sourceLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.purple,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng!,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  displayActiveDriversOnUsersMap()
  {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarketSet = Set<Marker>();

      for(ActiveNearbyAvailableDrivers eachDriver in GeoFireAssistant.activeNearbyAvailableDriversList)
      {
        LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          rotation: 360,
        );

        driversMarketSet.add(marker);
      }

      setState(() {
        markersSet = driversMarketSet;
      });
    });
  }

  readLifePoints()
  {
    FirebaseDatabase.instance.ref()
        .child("passengers")
        .child(user.uid)
        .child("lifePoints")
        .onValue.listen((eventSnap)
    {
      // var finalLife, lifepoints;
      // lifepoints = eventSnap.snapshot.value;
      // finalLife = 0;
      // finalLife = --lifepoints;
      // print("Life: " + lifepoints.toString());
      if(eventSnap.snapshot.value == 0)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => SignIn(),
        ),
        );
        Fluttertoast.showToast(msg: "Sorry, your account has been suspended due to malicious activities. Please contact the admin from the TODA terminal.");
      }
    });
  }

  passengerIsOfflineNow()
  {
    Geofire.removeLocation(user.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref()
        .child("passenger")
        .child(user.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;
  }

  assignedDriverModal() async
  {
    notified=true;
    AudioPlayer().play(AssetSource('sounds/notif_sound.mp3'));
    await Timer(Duration(milliseconds: 800), () {
      showDialog(
        context: context,
        builder: (context) => AssignedDriverWidget(),
      );
    });
  }

  computeFareAmount()
  async {
    print("success");
    var currentUserPositionLatLng = LatLng(
      userCurrentPosition!.latitude,
      userCurrentPosition!.longitude,
    );

    var tripDirectionDetails = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
      currentUserPositionLatLng,
      destinationLatLng!,
    );

    //fare amount
    double totalFareAmount = AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetails!);
    if(totalFareAmount == 1)
    {
      FirebaseDatabase.instance.ref()
          .child("fareAmount")
          .child("minAmount")
          .once()
          .then((snap)
      {
        if(snap.snapshot.value != null)
        {
          String fareAmount = snap.snapshot.value.toString();
          totalFareAmount = fareAmount.toDouble()!;

          FirebaseDatabase.instance.ref()
              .child("fareAmount")
              .child("bookingFee")
              .once()
              .then((snapShot)
          {
            String booking = snapShot.snapshot.value.toString();
            bookingFee = booking.toDouble()!;
            totalFareAmount = totalFareAmount + bookingFee;
            print("FareAmount: " + totalFareAmount.toString());

            FirebaseDatabase.instance.ref()
                .child("passengers")
                .child(currentFirebaseUser!.uid)
                .child("fareAmount")
                .set(totalFareAmount.toStringAsFixed(2));
          });
        }
      });
    }

    else if(totalFareAmount == 2)
    {
      FirebaseDatabase.instance.ref()
          .child("fareAmount")
          .child("maxAmount")
          .once()
          .then((snap)
      {
        if(snap.snapshot.value != null)
        {
          String fareAmount = snap.snapshot.value.toString();
          totalFareAmount = fareAmount.toDouble()!;

          FirebaseDatabase.instance.ref()
              .child("fareAmount")
              .child("bookingFee")
              .once()
              .then((snapShot)
          {
            String booking = snapShot.snapshot.value.toString();
            bookingFee = booking.toDouble()!;
            totalFareAmount = totalFareAmount + bookingFee;
            print("FareAmount: " + totalFareAmount.toString());

            FirebaseDatabase.instance.ref()
                .child("passengers")
                .child(currentFirebaseUser!.uid)
                .child("fareAmount")
                .set(totalFareAmount.toStringAsFixed(2));
          });
        }
      });
    }
  }

  getFareAmount()
  {
    FirebaseDatabase.instance.ref()
        .child("passengers")
        .child(user.uid)
        .child("fareAmount")
        .onValue.listen((value)
    {
      if(value.snapshot.value != null)
      {
        String fareAmount = value.snapshot.value.toString();
        totalFareAmount = fareAmount.toDouble()!;
        print("DialogAmount: " + totalFareAmount.toString());
      }
    });
  }
}
