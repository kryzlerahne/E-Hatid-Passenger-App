import 'dart:async';
//import 'package:ehatid_driver_app/constants.dart';
import 'package:ehatid_passenger_app/confirmCancellation.dart';
import 'package:ehatid_passenger_app/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'constants.dart';

class BookingComplete extends StatefulWidget {
  const BookingComplete({Key? key}) : super(key: key);

  @override
  _BookingComplete createState() => _BookingComplete();
}
class _BookingComplete extends State<BookingComplete> {

  @override
  void initState() {
    //seconds of wait for loading screen
    //Timer(const Duration(seconds: 6), (){
      //after 6 seconds
     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
       // return const Navigation();
      //}));
   // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: size.height,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Image.asset("assets/images/Vector 10.png",
                        width: Adaptive.w(100),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Center(
                      child: Image.asset("assets/images/ehatid logo.png",
                      ),
                    ),
                    SizedBox(height: Adaptive.h(1.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "You are ready to go!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.sp, fontWeight: FontWeight.bold),

                        ),

                        Icon(
                          Icons.verified_rounded,
                          size: 25.sp,
                          color: Color(0xFF0CBC8B),
                        ),
                      ],
                    ),
                    Text(
                      "Please wait patiently. Your driver is on the way.", textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.sp, color: Color(0xff272727), letterSpacing: -1, fontWeight: FontWeight.w500),
                    ),
                    //SizedBox(height: Adaptive.h(5)),
                     //Spacer(),

                  ],

                ),


              ),
              Positioned(
                top:Adaptive.h(78),
                left: Adaptive.w(14),
                child: Column(
                  children: [
                    MaterialButton(
                      onPressed: (){
                         showDialog(
                           context: context,
                           builder: (context) => cancelDialog(),
                         );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      minWidth: Adaptive.w(60),
                      child: Text("Cancel Booking", style: TextStyle( color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,),),
                      color: Color(0XFFE74338),
                    ),
                    SizedBox(height: Adaptive.w(2)),
                    Text(
                      "Note: Please be aware that there will be  a \n demerit  in your life points.", textAlign: TextAlign.center,
                      style: TextStyle(fontStyle:FontStyle. italic, fontFamily: 'Montserrat', fontSize: 16.sp, color: Color(0xff272727), letterSpacing: -1, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
class cancelDialog extends StatelessWidget {
  const cancelDialog({Key? key}) : super(key: key);

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
                               fontSize: 17,
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
                                 showDialog(
                                   context: context,
                                    builder: (context) => confirmCancel(),
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
                               //showDialog(
                               //    context: context,
                               //     builder: (context) => cancelDialog(),
                               //   );
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
}
