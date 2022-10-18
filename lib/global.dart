import 'package:ehatid_passenger_app/assistant_methods.dart';
import 'package:ehatid_passenger_app/direction_details_info.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList= []; //online active drivers info list
DirectionDetailsInfo? tripDirectionDetailsInfo;
