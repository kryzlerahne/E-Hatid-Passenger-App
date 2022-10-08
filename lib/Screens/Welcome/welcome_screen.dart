import 'dart:async';
import 'package:ehatid_passenger_app/Screens/IntroSlider/intro.dart';
import 'package:ehatid_passenger_app/Screens/Welcome/components/body.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}
class _WelcomeScreen extends State<WelcomeScreen> {

  @override
  void initState() {
    //seconds of wait for loading screen
    Timer(const Duration(seconds: 5), (){
      //after 5 seconds
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return const HomeScreen();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: SingleChildScrollView(
        child: Body(),
      ),
    );
  }
}