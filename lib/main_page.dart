import 'package:ehatid_passenger_app/Screens/Login/sign_in.dart';
import 'package:ehatid_passenger_app/Screens/Home/homescreen.dart';
import 'package:ehatid_passenger_app/Screens/Welcome/welcome_screen.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:ehatid_passenger_app/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MapSample();
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}