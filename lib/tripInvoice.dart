import 'package:ehatid_passenger_app/assistant_methods.dart';
import 'package:ehatid_passenger_app/cancellation.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class tripInvoice extends StatefulWidget {

  @override
  State<tripInvoice> createState() => _tripInvoiceState();

}

class _tripInvoiceState extends State<tripInvoice> {

  String formattedDate = DateFormat.yMMMMd('en_US').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Color(0XFFFFFCEA),
        child: Container(
          height: 480,
          width: 900,
          decoration: BoxDecoration(
            color: Color(0XFFFFFCEA),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 29,
                left: -20,
                child: Container(
                  child: Image.asset("assets/images/BgTrip.png",
                      width: Adaptive.w(92),
                  ),
                  ),
              ),
              Positioned(
                top: 410,
                left: 50,
                right: 50,
                child: MaterialButton(
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(60),
                  child: Text("Done", style: TextStyle( color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),),
                  color: Color(0XFF0CBC8B),
                ),
              ),
              Positioned(
                top: Adaptive.h(6),
                left: Adaptive.w(5),
                child: Center(
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: <Widget> [
                            Text("Summary Details",
                              style: TextStyle(fontFamily: 'Montserrat',
                                letterSpacing: -1.09766, fontSize: Adaptive.sp(20), fontWeight: FontWeight.w700, color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: Adaptive.w(12),),
                            Text(fareAmount,
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: Adaptive.sp(17), fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: Adaptive.w(12),),
                          ],
                        ),

                        Row(
                          children: [
                            SizedBox(width: Adaptive.w(5),),
                            Text(formattedDate,
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: Adaptive.sp(17),
                              ),
                            ),
                            SizedBox(width: Adaptive.w(5),),
                          ],
                        ),
                        SizedBox(height: Adaptive.h(2),),
                        FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            children: [
                              SizedBox(width: Adaptive.w(4),),
                              Image.asset("assets/images/line.png",
                              height: Adaptive.h(8),
                              ),
                              SizedBox(width: 2,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: Adaptive.w(58),
                                    child: Text(userCurrentLocation,
                                      style: TextStyle(fontFamily: 'Montserrat',fontSize: Adaptive.sp(16)),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ), //PLACE YOUR LOCATION HERE
                                  SizedBox(height: 10,),
                                  Center(
                                    child: Container(
                                      width: 200,
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Adaptive.h(1),),
                                  Container(
                                    width: Adaptive.w(60),
                                    child: Text(userDropOffAddress,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: 'Montserrat', fontSize: Adaptive.sp(16)),),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Adaptive.h(5),),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Adaptive.h(26),
                left: Adaptive.w(10),
                child: Row(
                children: [
                SizedBox(height: Adaptive.h(8),),
                Container(
                    width: Adaptive.w(24),
                    child: Text("Booking ID:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: Adaptive.sp(16),
                      ),
                    ),
                  ),
                SizedBox(width: Adaptive.w(5),),
                Container(
                  width: Adaptive.w(30),
                  child: Text(requestId,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: Adaptive.sp(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ),

                    ],
                  ),
                ),
              Positioned(
                top: Adaptive.h(30),
                left: Adaptive.w(10),
                child: Row(
                  children: [
                    SizedBox(height: Adaptive.h(8),),
                    Container(
                      width: Adaptive.w(27),
                      child: Text("Driver Name:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: Adaptive.w(5),),
                    Container(
                      width: Adaptive.w(30),
                      child: Text(driverName,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: Adaptive.h(34),
                left: Adaptive.w(10),
                child: Row(
                  children: [
                    SizedBox(height: Adaptive.h(8),),
                    Container(
                      width: Adaptive.w(29),
                      child: Text("Plate Number:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: Adaptive.w(5),),
                    Container(
                      width: Adaptive.w(27),
                      child: Text(driverTricDetails,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: Adaptive.h(38),
                left: Adaptive.w(10),
                child: Row(
                  children: [
                    SizedBox(height: Adaptive.h(8),),
                    Container(
                      width: Adaptive.w(27),
                      child: Text("Driver Phone:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: Adaptive.w(5),),
                    Container(
                      width: Adaptive.w(27),
                      child: Text(driverPhone,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: Adaptive.h(42),
                left: Adaptive.w(10),
                child: Row(
                  children: [
                    SizedBox(height: Adaptive.h(8),),
                    Container(
                      width: Adaptive.w(32),
                      child: Text("Estimated Fare:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: Adaptive.w(5),),
                    Container(
                      width: Adaptive.w(24),
                      child: Text(fareAmount,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      );
  }
}

