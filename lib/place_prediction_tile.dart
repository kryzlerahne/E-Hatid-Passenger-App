import 'package:ehatid_passenger_app/predicted_places.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PlacePredictionTileDesign extends StatelessWidget
{
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()
      {

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
                    predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle( color: Color(0xbc000000),
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,),
                  ),
                  SizedBox(height: Adaptive.h(0.5),),
                  Text(
                    predictedPlaces!.secondary_text!,
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
