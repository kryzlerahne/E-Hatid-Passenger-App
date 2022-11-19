import 'package:ehatid_passenger_app/confirmCancellation.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'constants.dart';

class cancelDialog extends StatefulWidget {

  @override
  State<cancelDialog> createState() => _cancelDialogState();
}

class _cancelDialogState extends State<cancelDialog> {
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
                      Text("Warning",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 22.sp,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Icon(
                        Icons.warning_amber_rounded,
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
                Text("A demerit on your life points \nwill be enacted automatically upon\nyour action. Are you sure you want\nto cancel?",
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
                    computeLifePoints();
                    Future.delayed(Duration(seconds: 10), () {
                      FirebaseDatabase.instance.ref().child("All Ride Requests")
                          .child(rideRequestId)
                          .child("status")
                          .set("cancelled");
                    });
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (_) => confirmCancel(),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(30),
                  child: Text("Yes", style: TextStyle( color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),),
                  color: Color(0XFF0CBB8A),
                ),
                SizedBox(width: 5.w,),
                MaterialButton(
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(30),
                  child: Text("No", style: TextStyle( color: Colors.white,
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

  computeLifePoints()
  {
    FirebaseDatabase.instance.ref()
        .child("passengers")
        .child(user.uid)
        .update({"lifePoints": ServerValue.increment(-1)});
  }
}

