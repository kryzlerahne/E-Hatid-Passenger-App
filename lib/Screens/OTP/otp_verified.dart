import 'dart:async';

import 'package:ehatid_passenger_app/Screens/Login/components/register.dart';
import 'package:flutter/material.dart';

class OtpVerified extends StatefulWidget {
  const OtpVerified({Key? key}) : super(key: key);

  @override
  _OtpVerified createState() => _OtpVerified();
}
class _OtpVerified extends State<OtpVerified> {

  @override
  void initState() {
    //seconds of wait for loading screen
    Timer(const Duration(seconds: 3), (){
      //after 5 seconds
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return const RegisterPage();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Image.asset(
                    "assets/images/check.png",
                  ),
                  Text(
                    "Phone Verified!", textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        color: Color.fromARGB(255, 33, 33, 33),
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}