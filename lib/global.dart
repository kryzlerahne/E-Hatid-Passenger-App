import 'package:ehatid_passenger_app/assistant_methods.dart';
import 'package:ehatid_passenger_app/direction_details_info.dart';
import 'package:ehatid_passenger_app/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList= []; //online active drivers info list
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken = "key=AAAAI12SKic:APA91bEBXIQCZlwAZlLzIeuPNd5nQAUpKL4AhWvQkLtNIb3wu55BWO_-dcSRrcyeuEraWGSCVTt573S3fpT2ajuUOLXssSH0mIBSdrOPT7cfNQreYaLRDJPiEXKcjP_tdTQ2rSpd6VkQ";
String userDropOffAddress = "";
String driverTricDetails = "";
String driverPhone = "";
String driverName = "";
double countRatingStars = 0.0;
String titleStarsRating="";
