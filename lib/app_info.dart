import 'package:ehatid_passenger_app/directions.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/trips_history_model.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier
{
    Directions? userPickUpLocation, userDropOffLocation;
    int countTotalTrips = 0;
    List<String> historyTripsKeysList = [];
    List<TripsHistoryModel> allTripsHistoryInformationList = [];
    String driverRates = "0";
    String finalLifePoints = "0";

    void updatePickUpLocationAddress(Directions userPickUpAddress)
    {
      userPickUpLocation = userPickUpAddress;
      notifyListeners();
    }

    void updateDropOffLocationAddress(Directions dropOffAddress)
    {
      userDropOffLocation = dropOffAddress;
      notifyListeners();
    }

    updateOverAllTripsCounter(int overAllTripsCounter)
    {
      countTotalTrips = overAllTripsCounter;
      notifyListeners();
    }

    updateOverAllTripsKeys(List<String> tripsKeysList)
    {
      historyTripsKeysList = tripsKeysList;
      notifyListeners();
    }

    updateOverAllTripsHistoryInformation(TripsHistoryModel eachTripHistory)
    {
      allTripsHistoryInformationList.add(eachTripHistory);
      notifyListeners();
    }
    updateLifePoints(String passengerLife)
    {
      finalLifePoints = passengerLife;
    }
    updateRatings(String rating)
    {
      driverRates = rating;
      print("eto na:"+ driverRates);
    }
}