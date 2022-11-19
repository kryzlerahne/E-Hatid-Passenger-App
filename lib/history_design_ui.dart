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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20),),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFFED90F),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 2.0),
                      child: Text(
                        "Driver: " + widget.tripsHistoryModel!.driverName!,
                        style: TextStyle( color: Color(0xbc000000),
                          fontSize: 15,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 1.w,),
                Text(
                  "Php " + widget.tripsHistoryModel!.fareAmount!,
                  style: TextStyle( color: Color(0xFF0CBC8B),
                    fontSize: 16,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w800,),
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
                    fontSize: 13,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400,),
                ),
              ],
            ),

            SizedBox(height: Adaptive.h(1),),

            //icon + pickup
            Container(
              decoration: BoxDecoration(
                color: Color(0XFFEBE5D8),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                child: Row(
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
                            fontSize: 13,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Adaptive.h(1),),

            //icon + dropOff
            Container(
              decoration: BoxDecoration(
                color: Color(0XFFEBE5D8),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                child: Row(
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
                            fontSize: 13,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 2.0),
                    child: Text(
                      formatDateAndTime(widget.tripsHistoryModel!.time!),
                      style: TextStyle( color: Color(0xbc000000),
                        fontSize: 13,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
