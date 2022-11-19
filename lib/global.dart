import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ehatid_passenger_app/assistant_methods.dart';
import 'package:ehatid_passenger_app/direction_details_info.dart';
import 'package:ehatid_passenger_app/passenger_data.dart';
import 'package:ehatid_passenger_app/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';


final FirebaseAuth fAuth = FirebaseAuth.instance;
StreamSubscription<Position>? streamSubscriptionPosition;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList= []; //online active drivers info list
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken = "key=AAAAI12SKic:APA91bEBXIQCZlwAZlLzIeuPNd5nQAUpKL4AhWvQkLtNIb3wu55BWO_-dcSRrcyeuEraWGSCVTt573S3fpT2ajuUOLXssSH0mIBSdrOPT7cfNQreYaLRDJPiEXKcjP_tdTQ2rSpd6VkQ";
String userCurrentLocation = "";
String userDropOffAddress = "";
String driverTricDetails = "";
String driverPhone = "";
String notified = "";
String driverName = "";
String rateDriver = "";
double ratingDriver = 0;
String driverId = "";
double finalLife = 0.0;
double countRatingStars = 0.0;
double lifePoints = 3.0;
String titleStarsRating="";
String fareAmount ="";
String requestId="";
String rideRequestId="";

PassengerData onlinePassengerData = PassengerData();
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
