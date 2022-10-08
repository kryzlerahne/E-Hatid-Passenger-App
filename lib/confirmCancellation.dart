import 'dart:async';
import 'package:ehatid_passenger_app/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'constants.dart';

class confirmCancel extends StatefulWidget {
  const confirmCancel({Key? key}) : super(key: key);

  @override
  State<confirmCancel> createState() => _confirmCancelState();
}

class _confirmCancelState extends State<confirmCancel> {
  @override
  void initState() {
    //seconds of wait for loading screen
    Timer(const Duration(seconds: 6), (){
    //after 6 seconds
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return const Navigation();
    }));
     });
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
              Positioned(
                top: 10.h,
                child: Column(
             // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Row(

                    children: [
                      Image.asset("assets/images/bgCancel.png",
                       width: 60.w,
                ),
                    ],
                  ),
                  //SizedBox(height: Adaptive.h(2)),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Text(
                  "Your booking was cancelled!",
                  textAlign: TextAlign.center,
                  style: TextStyle(letterSpacing: -1, fontFamily: 'Montserrat', fontSize: 20.sp, fontWeight: FontWeight.bold,),

                  ),
                    SizedBox(height: Adaptive.h(7)),


      ],
  ),
                    Text(
                    "Your life points will be deducted accordingly,\nand this will serve as a warning. We hope no more \ncancellation the next time you book a ride. \nThank you!", textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.sp, color: Color(0xff272727), letterSpacing: -1, fontWeight: FontWeight.w500),
                    ),
                    //SizedBox(height: Adaptive.h(5)),
                    //Spacer(),

            ],
          ),
              ),
                Positioned(
                  top:Adaptive.h(60),
                  left: Adaptive.w(17),
                   child: Column(
                   children: [
                      MaterialButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Navigation())
                          );},
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                      ),
                      minWidth: Adaptive.w(40),
                          child: Text("Close", style: TextStyle( color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,),),
                          color: Color(0XFFE74338),
                          ),
                     SizedBox(height: Adaptive.w(45)),

                     Text(
                     "You will be redirected to the homepage.", textAlign: TextAlign.center,
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

