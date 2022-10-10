import 'dart:async';
import 'dart:math';
import 'package:ehatid_passenger_app/Screens/Wallet/wallet.dart';
import 'package:ehatid_passenger_app/accept_decline.dart';
import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/location_service.dart';
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
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  GoogleMapController? newGoogleMapController;

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.7731, 121.0484),
    zoom: 14.4746,
  );

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

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
    _setMarker(LatLng(37.42796133580664, -122.085749655962));

    checkIfLocationPermissionAllowed();
  }

  void _setMarker(LatLng point){
    setState(() {
      _markers.add(
          Marker(markerId: MarkerId('marker'),
            position: point,
          ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
    ),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.purple,
        points: points.map((point) => LatLng(point.latitude, point.longitude),
        ).toList(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
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
              markers: _markers,
              polygons: _polygons,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                locateUserPosition();
              },
              onTap: (point) {
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Adaptive.w(3),),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_pin,  color: Color(0xffCCCCCC)),
                              SizedBox(width: Adaptive.w(1.5),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("From",
                                  style: TextStyle(color: Color(0xbc000000),
                                    fontSize: 15,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w400,)),
                            ],
                            ),
                            ],

                          ),
                          /**TextFormField(
                            controller: _originController,
                            //textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              print(value);
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
                          Provider.of<AppInfo>(context).userPickUpLocation != null
                             ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!
                              : "your current location",
                          hintStyle: TextStyle( color: Color(0xbc000000),
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,),
                          fillColor: Colors.white,
                          filled: true,
                              suffixIcon: Icon(Icons.location_pin,  color: Color(0xffCCCCCC))
                          ),
                          ),**/
                          Text(Provider.of<AppInfo>(context).userPickUpLocation != null
                              ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!
                              : "your current location",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,)),
                          SizedBox(height: Adaptive.h(1.5),),
                          TextFormField(
                            controller: _destinationController,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              print(value);
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
                              hintText: "Destination",
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
                  ),
                 /** IconButton(
                    onPressed: () async {
                      var directions = await LocationService().getDirections(
                          _originController.text,
                          _destinationController.text
                      );
                      _goToPlace(
                        directions['start_location']['lat'],
                        directions['start_location']['lng'],
                        directions['bounds_ne'],
                        directions['bounds_sw'],
                      );

                      _setPolyline(directions['polyline_decoded']);
                    },
                    icon: Icon(Icons.search),
                  ),**/
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
                  var directions = await LocationService().getDirections(
                      _originController.text,
                      _destinationController.text
                  );
                  _goToPlace(
                    directions['start_location']['lat'],
                    directions['start_location']['lng'],
                    directions['bounds_ne'],
                    directions['bounds_sw'],
                  );

                  _setPolyline(directions['polyline_decoded']);
                  Timer(const Duration(seconds: 4), (){
                    //after 6 seconds
                    showDialog(
                      context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (_) => AcceptDecline(),
                            ),
                            );});
                          return BookingSuccessDialog();
                        }
                    );
                  });
                },
              ),
              SizedBox(height: Adaptive.h(1.5),),
            ],
          ),
        ],
      ),
    );
  }

  /**@override
  Widget build(BuildContext context) {
    final paneHeightClosed = 100.00;
    final paneHeightOpen = 100.00;
    final panelController = PanelController();

    return Scaffold(
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
      body: SlidingUpPanel(
        controller: panelController,
        minHeight: paneHeightClosed,
        maxHeight: paneHeightOpen,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        color: Color(0xFFEBE5D8),
        body: GoogleMap(
          mapType: MapType.normal,
          markers: _markers,
          polygons: _polygons,
          polylines: _polylines,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: (point) {
            setState(() {
              polygonLatLngs.add(point);
              _setPolygon();
            });
          },
        ),
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
          panelController: panelController,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
    );
  }**/

  Future<void> _goToPlace(
      //Map<String, dynamic> place,
      double lat,
      double lng,
      Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw,

      ) async {
   // final double lat = place['geometry']['location']['lat'];
   // final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controllerGoogleMap.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
              northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );

    _setMarker(LatLng(lat, lng));
  }
}

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ListView(
        padding: EdgeInsets.zero,
        controller: controller,
        children: <Widget>[
          SizedBox(height: 10),
          SizedBox(height: 10),
        ],
      );
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
