import 'dart:async';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Screens/IntroSlider/components/intro_slider.dart';
import 'Screens/IntroSlider/intro.dart';
import 'assistant_methods.dart';

import 'global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    //seconds of wait for loading screen
    Timer(const Duration(seconds: 6), (){
      //after 6 seconds
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return IntroSliderPage();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: Image.asset("assets/images/ehatid pass.png",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}