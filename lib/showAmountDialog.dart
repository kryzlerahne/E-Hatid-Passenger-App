import 'package:ehatid_passenger_app/confirmCancellation.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class ShowAmount extends StatefulWidget {

  @override
  State<ShowAmount> createState() => _ShowAmountState();
}

class _ShowAmountState extends State<ShowAmount> {
  final user = FirebaseAuth.instance.currentUser!;

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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.1,
              decoration: BoxDecoration(
                color: Color(0XFFFED90F),
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
                      Text("Do you want to proceed?",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 19,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: Adaptive.w(1),),
                      Icon(
                        Icons.wallet,
                        size: 25,
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
                Text(
                  "The total fare amount of \nyour trip is: Php " + totalFareAmount.toStringAsFixed(2) + "\n Do you want to proceed anyways?",
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
                  onPressed: () {
                    Navigator.pop(context, "AgreedFareAmount");
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(30),
                  child: Text("Yes", style: TextStyle(color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),),
                  color: Color(0XFF0CBB8A),
                ),
                SizedBox(width: 5.w,),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(30),
                  child: Text("No", style: TextStyle(color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),),
                  color: Color(0XFFE74338),
                ),


              ],
            ),
          ],
        ),

      ),
    );
  }
}

