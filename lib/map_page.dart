import 'dart:async';
import 'dart:math';
import 'package:ehatid_passenger_app/Screens/Wallet/wallet.dart';
import 'package:ehatid_passenger_app/accept_decline.dart';
import 'package:ehatid_passenger_app/active_nearby_available_drivers.dart';
import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/direction_details_info.dart';
import 'package:ehatid_passenger_app/geofire_assistant.dart';
import 'package:ehatid_passenger_app/location_service.dart';
import 'package:ehatid_passenger_app/main.dart';
import 'package:ehatid_passenger_app/processing_dialog.dart';
import 'package:ehatid_passenger_app/progress_dialog.dart';
import 'package:ehatid_passenger_app/search_places_screen.dart';
import 'package:ehatid_passenger_app/select_nearest_active_driver_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'assistant_methods.dart';
import 'global.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  bool isVisible = true;

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

  String userName = "";
  String userId = "";

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

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(userCurrentPosition!, context);
    print("this is your address =" + humanReadableAddress);

    //userName = userModelCurrentInfo!.username!;
    //userId = userModelCurrentInfo!.id!;

    initializeGeoFireListener(); //Active Drivers
  }


  @override
  void initState() {
    super.initState();
    //_setMarker(LatLng(37.42796133580664, -122.085749655962));
    AssistantMethods.readCurrentOnlineUserInfo();
    checkIfLocationPermissionAllowed();
  }

  saveRideRequestInformation() //Ride Request Code
  {
    //1. save the Ride Request Information

    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Requests").push(); // Creates unique ID

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
      "username": userModelCurrentInfo!.username!,
      "email": userModelCurrentInfo!.email!,
      "id": userModelCurrentInfo!.id!,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription = referenceRideRequest!.onValue.listen((eventSnap) // getting updates in real time
    {
      if(eventSnap.snapshot.value == null)
        {
          return;
        }

      if ((eventSnap.snapshot.value as Map)["driverPlateNum"] != null) //!! GAWING CAR DETAILS/ PLATE NUMBER
      {
        setState(() {
          driverTricDetails = (eventSnap.snapshot.value as Map)["driverPlateNum"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) //!! GET PHONE NUMBER
          {
        setState(() {
          driverPhone = (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverName"] != null) //!! GET FNAME
          {
        setState(() {
          driverName = (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["status"] != null)
      {
        userRideRequestStatus = (eventSnap.snapshot.value as Map)["status"].toString();
      }

      if((eventSnap.snapshot.value as Map)["driverLocation"] != null)
      {
        double driverCurrentPositionLat = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
        double driverCurrentPositionLng = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());

        LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        //when status = accepted
        if(userRideRequestStatus == "accepted")
        {
          updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
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
      }
    });

    onlineNearbyAvailableDriversList = GeoFireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
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

  searchNearestOnlineDrivers() async
  {
    //no active driver available
    if(onlineNearbyAvailableDriversList.length == 0)
      {
        //cancel/delete the ride request
        referenceRideRequest!.remove();

        setState(() {
          polyLineSet.clear();
          markersSet.clear();
          circlesSet.clear();
          pLineCoOrdinatesList.clear();
        });

        Fluttertoast.showToast(msg: "No Online Nearby Drivers");


        return;
      }

    //there are active drivers available
    await retrieveOnlineDriversInformation(onlineNearbyAvailableDriversList);
    
    var response = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SelectNearestActiveDriversScreen(referenceRideRequest : referenceRideRequest)));

    if(response == "driverChoosed")
    {
      FirebaseDatabase.instance.ref()
          .child("drivers")
          .child(chosenDriverId!)
          .once()
          .then((snap)
      {
        if(snap.snapshot.value != null)
          {
            //send notification to that specific driver
            sendNotificationToDriverNow(chosenDriverId!);

            //Display Waiting Response from a Driver UI
            showWaitingResponseFromDriverUI();

            //Response from the driver
            FirebaseDatabase.instance.ref()
                .child("drivers")
                .child(chosenDriverId!)
                .child("newRideStatus")
                .onValue.listen((eventSnapshot)
            {
              //driver can cancel the RideRequest Push Notifications
              //(newRideStatus = idle)
              if(eventSnapshot.snapshot.value == "idle")
              {
                Fluttertoast.showToast(msg: "The driver has cancelled your request. Please choose another driver.");

                Future.delayed(const Duration(milliseconds: 3000), ()
                {
                  Fluttertoast.showToast(msg: "Please Restart app now.");

                  SystemNavigator.pop();
                });
              }

              //accept the riderequest push notification
              //(newRideStatus = accepted)
              if(eventSnapshot.snapshot.value == "accepted")
              {
                //design and display ui for displaying driver information
                showUIForAssignedDriverInfo();
              }
            });
          }
          else
          {
            Fluttertoast.showToast(msg: "This driver do not exist. Try again.");
          }
      });
    }
  }

  showUIForAssignedDriverInfo()
  {
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      assignedDriverInfoContainerHeight = Adaptive.h(30);
    });
  }

  showWaitingResponseFromDriverUI()
  {
    setState(() {
      isVisible = !isVisible;
      waitingResponseFromDriverContainerHeight = Adaptive.h(30);

        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return ProcessingBookingDialog();
            });
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
        leading: IconButton(
          onPressed: () {
            //Navigator.pop(context);
            SystemNavigator.pop();
            },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
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
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

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
                      "Hello " + userModelCurrentInfo!.username!.toString() + "!"  ,
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
                            //controller: _destinationController,
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
                  onPressed: () async
                  {
                    if(Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null)
                      {
                        saveRideRequestInformation();
                        //showDialog(
                        //  context: context,
                        //  builder: (context) => ActiveDriver(),
                        //);
                        //Navigator.push(context, MaterialPageRoute(builder: (c)=> AcceptDecline()));
                      }
                    else
                      {
                        Fluttertoast.showToast(msg: "Please select your destination location first.");
                      }
                  },
                ),
                SizedBox(height: Adaptive.h(1.5),),
              ],
            ),

          //ui for waiting response from the driver
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDriverContainerHeight,
              decoration: const BoxDecoration(
                color: Color(0xFFFED90F),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text("Please wait...",
                  style: TextStyle( color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),
                  ),
                ),
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
                color: Color(0xFFEBE5D8),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(driverRideStatus,
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.3.w, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Adaptive.h(2),
                    ),
                    Divider(
                      height: 0.5.h,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: Adaptive.h(2),
                    ),
                    Center(
                      child: Text(driverName,
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.3.w, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Adaptive.h(0.5),
                    ),
                    Center(
                      child: Text(driverTricDetails,
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.3.w, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Adaptive.h(2),
                    ),
                    Divider(
                      height: 0.5.h,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: Adaptive.h(1),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: ()
                        {

                        },
                        style: ElevatedButton.styleFrom(
                          primary:  Color(0xFF0CBC8B),
                        ),
                        icon: Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 22,
                        ),
                        label: Text(
                          "Call Driver",
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.3.w, fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition!.locationLongitude!);

    BookingSuccessDialog();

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(sourceLatLng, destinationLatLng);

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
         color: Colors.red,
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
     if(sourceLatLng.latitude > destinationLatLng.latitude && sourceLatLng.longitude > destinationLatLng.longitude)
     {
        boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: sourceLatLng);
     }
     else if(sourceLatLng.longitude > destinationLatLng.longitude)
     {
       boundsLatLng = LatLngBounds(
           southwest: LatLng(sourceLatLng.latitude, destinationLatLng.longitude),
           northeast: LatLng(destinationLatLng.latitude, sourceLatLng.longitude),
       );
     }
     else if(sourceLatLng.latitude > destinationLatLng.latitude)
     {
       boundsLatLng = LatLngBounds(
         southwest: LatLng(destinationLatLng.latitude, sourceLatLng.longitude),
         northeast: LatLng(sourceLatLng.latitude, destinationLatLng.longitude),
       );
     }
     else
       {
         boundsLatLng = LatLngBounds(southwest: sourceLatLng, northeast: destinationLatLng);
       }

     newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

     Marker originMarker = Marker(
        markerId: const MarkerId("originID"),
       infoWindow: InfoWindow(title: sourcePosition.locationName, snippet: "Origin"),
       position: sourceLatLng,
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
     );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
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
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  //Section 17: Para Mapalabas ang ACTIVE
  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 20)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack)
        {
          case Geofire.onKeyEntered: //whenever any driver become active or online
            ActiveNearbyAvailableDrivers activeNearbyAvailableDrivers = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDrivers.locationLatitude = map['latitude'];
            activeNearbyAvailableDrivers.locationLongitude = map['longitude'];
            activeNearbyAvailableDrivers.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList.add(activeNearbyAvailableDrivers);
            if(activeNearbyDriverKeysLoaded == true)
              {
                displayActiveDriversOnUsersMap();
              }
            break;

          case Geofire.onKeyExited: //whenever any driver become non-active or offline
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            break;

          //whenever the driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDrivers = ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDrivers.locationLatitude = map['latitude'];
            activeNearbyAvailableDrivers.locationLongitude = map['longitude'];
            activeNearbyAvailableDrivers.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriveLocation(activeNearbyAvailableDrivers);
            displayActiveDriversOnUsersMap();
            break;

          //display those online drivers on users map
          case Geofire.onGeoQueryReady:
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
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

}

class BookingSuccessDialog extends StatelessWidget {
  final _priceController = TextEditingController();
  BookingSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: Adaptive.h(36)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19)
      ),
      child: Container(
        width: Adaptive.w(80),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Adaptive.h(4),),
                SpinKitFadingCircle(
                  color: Colors.black,
                  size: 50,
                ),
                Container(
                  width: Adaptive.w(60),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          SizedBox(height: Adaptive.h(1),),
                          Text("Processing Booking...",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 20,
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Booking ID: 554321",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],),
      ),
    );
  }
}