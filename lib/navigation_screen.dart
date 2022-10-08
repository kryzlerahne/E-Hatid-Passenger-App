import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;
import 'main.dart';

class DriverMap extends StatefulWidget {
  @override
  State<DriverMap> createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Driver',
            style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Fetching destination...',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: latController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'latitude',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: lngController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'longitude',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NavigationScreen(
                          double.parse(latController.text),
                          double.parse(lngController.text))));
                },
                child: Text('Get Directions'),
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFED90F),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
            ),
        ],
        ),
      ),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  final double lat;
  final double lng;
  NavigationScreen(this.lat, this.lng);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;
  loc.LocationData? _currentPosition;
  LatLng curLocation = LatLng(13.7731, 121.0484);
  StreamSubscription<loc.LocationData>? locationSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNavigation();
    addMarker();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
        backgroundColor: Color(0xFFFED90F),
      ),
      body: sourcePosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: curLocation,
              zoom: 16,
            ),
            markers: {sourcePosition!, destinationPosition!},
            onTap: (latLng) {
              print(latLng);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 30,
            left: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                        (route) => false);
              },
              child: Icon(Icons.arrow_back),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.navigation_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        'google.navigation:q=${widget.lat}, ${widget.lng}&key=AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io'));
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 30.w,
            top: 20.h,
            child: Container(
              height: Adaptive.h(5),
              width: Adaptive.h(22),
              child: GoOnline(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget GoOnline(BuildContext context) => FloatingActionButton.extended(
    label: Text('I have arrived',
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
    ),
    backgroundColor: Color(0xFF0CBC8B),
    onPressed: (){
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19)
          ),
          child: Container(
            height: 45.h,
            child: Column(
              children: [
                Container(
                  height: 53.0,
                  decoration: BoxDecoration(
                    color: Color(0XFF0CBB8A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Karlo Pangilinan",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 5.3.w,
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 1.w,),
                          Icon(Icons.verified_rounded,
                            color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Adaptive.h(2),),
                FittedBox(
                  fit: BoxFit.fill,
                  child: Row(
                    children: [
                      SizedBox(width: Adaptive.w(1),),
                      Image.asset("assets/images/line.png", height: Adaptive.h(16),),
                      SizedBox(width: Adaptive.w(1.5),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Pickup Point:",
                            style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600,color: Color(0XFF9E9E9E)),),
                          Text("7-Eleven, Bolbok, Batangas City",
                            style: TextStyle(fontFamily: 'Montserrat',),), //PLACE YOUR LOCATION HERE
                          SizedBox(height: Adaptive.h(2),),
                          Center(
                            child: Container(
                              width: 60.w,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Color(0XFFCCC9C1),
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                          ),
                          SizedBox(height: Adaptive.h(1),),
                          Text("Destination:",
                            style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, color: Color(0XFFFFBA4C)),),
                          Text("Sta. Rita de Cascia Parish Church",
                            style: TextStyle(fontFamily: 'Montserrat',),),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Adaptive.h(3),),
                Container(
                  width: Adaptive.w(90),
                  height: Adaptive.h(7),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Distance",
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,),
                          ),
                          Text("Time",
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //SizedBox(height: 20,),
                          Text("192m away",
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,color: Color(0XFFFFBA4C)),
                          ),
                          Text("15 mins",
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0XFFFFBA4C)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Adaptive.h(2),),
                MaterialButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) => BookingSuccessDialog(),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(40),
                  child: Text("Start Trip", style: TextStyle( color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),),
                  color: Color(0XFF0CBC8B),
                ),
              ],
            ),
          ),
        ),
      );
    },
    icon: Icon(Icons.beenhere, size: 17),
  );

  getNavigation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == loc.PermissionStatus.granted) {
      _currentPosition = await location.getLocation();
      curLocation =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
            controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
              zoom: 16,
            )));
            if (mounted) {
              controller
                  ?.showMarkerInfoWindow(MarkerId(sourcePosition!.markerId.value));
              setState(() {
                curLocation =
                    LatLng(currentLocation.latitude!, currentLocation.longitude!);
                sourcePosition = Marker(
                  markerId: MarkerId(currentLocation.toString()),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                  position:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
                  infoWindow: InfoWindow(
                      title: '${double.parse(
                          (getDistance(LatLng(widget.lat, widget.lng))
                              .toStringAsFixed(2)))} km'
                  ),
                  onTap: () {
                    print('market tapped');
                  },
                );
              });
              getDirections(LatLng(widget.lat, widget.lng));
            }
          });
    }
  }

  getDirections(LatLng dst) async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io',
        PointLatLng(curLocation.latitude, curLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng>polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance(LatLng destposition) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destposition.latitude, destposition.longitude);
  }
  addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: MarkerId('source'),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      destinationPosition = Marker(
        markerId: MarkerId('destination'),
        position: LatLng(widget.lat, widget.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
    });
  }
}

class BookingSuccessDialog extends StatelessWidget {
  final _priceController = TextEditingController();
  BookingSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19)
      ),
      child: Container(
        height: Adaptive.h(50),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color: Color(0XFF0CBB8A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Booking Successful!",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Passenger ID: 554321",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              child: Container(
                width: Adaptive.w(50),
                height: Adaptive.h(9),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("PHP",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.32,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: "Fare Price",
                            hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            //isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: Adaptive.h(7),),
                Text("Base Fare:",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: Adaptive.w(34),),
                Text("P40.00",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // SizedBox(height: Adaptive.h(2),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Booking Fee:",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: Adaptive.w(30),),
                Text("P10.00",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: Adaptive.h(3),),
            Center(
              child: Container(
                width: Adaptive.w(60),
                height: Adaptive.h(.2),
                decoration: BoxDecoration(
                  color: Color(0XFFCCC9C1),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            SizedBox(height: Adaptive.h(2),),
            Center(
              child: Container(
                height: Adaptive.h(8),
                child: Text(
                  "Don't worry! Additional charges may apply\n if cancellation of booking is done by\n the passenger.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            // SizedBox(height: Adaptive.h(3),),
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => DriverMap(),
                ),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              minWidth: Adaptive.w(50),
              child: Text("Get Directions", style: TextStyle( color: Colors.white,
                fontSize: 15,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,),),
              color: Color(0XFF0CBB8A),
            ),
          ],
        ),
      ),
    );
  }
}