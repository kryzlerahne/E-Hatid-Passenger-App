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
import 'package:ehatid_passenger_app/progress_dialog.dart';
import 'package:ehatid_passenger_app/search_places_screen.dart';
import 'package:ehatid_passenger_app/select_nearest_active_driver_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.7731, 121.0484),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  bool activeNearbyDriverKeysLoaded = false; //Activedrivers code

  List<ActiveNearbyAvailableDrivers> onlineNearbyAvailableDriversList = []; //Ride Request Code

  DirectionDetailsInfo? tripDirectionDetailsInfo;

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

    initializeGeoFireListener(); //Active Drivers
  }


  @override
  void initState() {
    super.initState();
    //_setMarker(LatLng(37.42796133580664, -122.085749655962));
    checkIfLocationPermissionAllowed();
  }

  saveRideRequestInformation() //Ride Request Code
  {
    //save the Ride Request Information

    onlineNearbyAvailableDriversList = GeoFireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();

  }

  searchNearestOnlineDrivers() async
  {
    //no active driver available
    if(onlineNearbyAvailableDriversList.length == 0)
      {
        //cancel/delete the ride request

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
    
    Navigator.push(context, MaterialPageRoute(builder: (c)=> SelectNearestActiveDriversScreen()));
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
            Navigator.pop(context);
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
                    "Hello Ktyzle!",
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
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
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

/**class BookingSuccessDialog extends StatelessWidget {
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
}**/