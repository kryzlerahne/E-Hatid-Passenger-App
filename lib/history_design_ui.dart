import 'package:ehatid_passenger_app/trips_history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HistoryDesignUIWidget extends StatefulWidget
{

  TripsHistoryModel? tripsHistoryModel;

  HistoryDesignUIWidget({this.tripsHistoryModel});

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}

class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget>
{
  String formatDateAndTime(String dateTimeFromDB)
  {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);

                  //Dec 10                              //2020                            //1:12am
    String formattedDateTime = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDateTime;
  }


  @override
  Widget build(BuildContext context)
  {
    return Container(
      color: Color(0XFF0CBC8B),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //driver name + fare amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Driver: " + widget.tripsHistoryModel!.driverName!,
                    style: TextStyle( color: Color(0xbc000000),
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400,),
                  ),
                ),

                SizedBox(width: 1.w,),

                Text(
                  "Php " + widget.tripsHistoryModel!.fareAmount!,
                  style: TextStyle( color: Color(0xbc000000),
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400,),
                ),
              ],
            ),

            SizedBox(height: Adaptive.h(1),),

            //PlateNumber
            Row(
              children: [
                Icon(
                  Icons.car_repair,
                  color: Colors.grey,
                ),


                SizedBox(width: 1.w,),

                Text(
                  widget.tripsHistoryModel!.driverPlateNum!,
                  style: TextStyle( color: Color(0xbc000000),
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400,),
                ),
              ],
            ),

            SizedBox(height: Adaptive.h(1),),

            //icon + pickup
            Row(
              children: [
                Icon(Icons.location_pin,
                color: Color(0xffCCCCCC),
                ),

                SizedBox(width: 1.w,),

                Expanded(
                  child: Container(
                    child: Text(
                      widget.tripsHistoryModel!.originAddress!,
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle( color: Color(0xbc000000),
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,),
                    ),
                  ),
                ),
              ],
            ),

            //icon + dropOff
            Row(
              children: [
                Icon(Icons.storefront,
                  color: Color(0xffCCCCCC),
                ),

                SizedBox(width: 1.w,),

                Expanded(
                  child: Container(
                    child: Text(
                      widget.tripsHistoryModel!.destinationAddress!,
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle( color: Color(0xbc000000),
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Text(
                  formatDateAndTime(widget.tripsHistoryModel!.time!),
                  style: TextStyle( color: Color(0xbc000000),
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400,),
                ),
              ],
            ),

            SizedBox(height: Adaptive.h(1),),

          ],
        ),
      ),
    );
  }
}
