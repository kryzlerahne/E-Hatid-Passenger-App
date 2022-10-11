import 'dart:async';
import 'dart:math';
import 'package:ehatid_passenger_app/Screens/Wallet/wallet.dart';
import 'package:ehatid_passenger_app/accept_decline.dart';
import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/location_service.dart';
import 'package:ehatid_passenger_app/progress_dialog.dart';
import 'package:ehatid_passenger_app/search_places_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'assistant_methods.dart';

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
  }


  @override
  void initState() {
    super.initState();
    //_setMarker(LatLng(37.42796133580664, -122.085749655962));
    checkIfLocationPermissionAllowed();
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
                    "Hello Kryzle!",
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
                child: Text("Continue", style: TextStyle( color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,),),
                color: Color(0XFF0CBC8B),
                onPressed: () async {
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