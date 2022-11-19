import 'package:ehatid_passenger_app/main.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LongWaitUI extends StatefulWidget {

  @override
  State<LongWaitUI> createState() => LongWaitUIState();
}

class LongWaitUIState extends State<LongWaitUI> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19)
      ),
      child: Container(
        height: 35.h,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color: Color(0XFFE74338),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No Available Drivers",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 20.sp,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Icon(
                        Icons.not_accessible,
                        size: 25.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15.h,),
                Text("Sorry! We are trying to connect you\nto a nearby driver but no one is\navailable around you. Please try\nagain later.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40,),
                MaterialButton(
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(30),
                  child: Text("Try Again", style: TextStyle( color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),),
                  color: Color(0XFF0CBB8A),
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}
