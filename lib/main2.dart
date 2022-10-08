import 'package:ehatid_passenger_app/Screens/Welcome/welcome_screen.dart';
import 'package:ehatid_passenger_app/constants.dart';
import 'package:ehatid_passenger_app/Screens/Home/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen = 0;

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var result = await preferences.getInt('initScreen');
  if(result != null){
    initScreen = result;
  }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: const Color(0xFFFED90F),
      ),
      //home: IntroSliderPage(),
      initialRoute: initScreen == 0 ? 'welcome' : 'homepage', // paltan ang login ng homepage
      routes: {
        'homepage' : (context) => WelcomeScreen(),
        'welcome' : (context) => WelcomeScreen(),
      },
    );
  }
}