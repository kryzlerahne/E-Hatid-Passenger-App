import 'package:ehatid_passenger_app/directions.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier
{
    Directions? userPickUpLocation;

    void updatePickUpLocationAddress(Directions userPickUpAddress)
    {
      userPickUpLocation = userPickUpAddress;
      notifyListeners();
    }
}