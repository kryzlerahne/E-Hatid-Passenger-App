import 'package:ehatid_passenger_app/Screens/Login/sign_in.dart';
import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/directions.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/predicted_places.dart';
import 'package:ehatid_passenger_app/processing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ehatid_passenger_app/request_assistant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';


class PlacePredictionTileDesign extends StatefulWidget
{
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeId, context) async
  {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProcessingBookingDialog(
          message: "Setting up drop off point..",
        ),
    );

    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io";

    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occured, Failed. No response.")
    {
      return;
    }

    if(responseApi["status"] == "OK")
    {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      Navigator.pop(context, "Obtained Destination Address");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()
      {
        getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFFCF7E1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Icon(
              Icons.add_location,
              color: Colors.black,
            ),
            SizedBox(width: Adaptive.w(5),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Adaptive.h(2),),
                  Text(
                    widget.predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle( color: Color(0xbc000000),
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,),
                  ),
                  SizedBox(height: Adaptive.h(0.5),),
                  Text(
                    widget.predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle( color: Color(0xbc000000),
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400,),
                  ),
                  SizedBox(height: Adaptive.h(2),),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
