import 'package:ehatid_passenger_app/Screens/IntroSlider/intro.dart';
import 'package:ehatid_passenger_app/Screens/Welcome/welcome_screen.dart';
import 'package:ehatid_passenger_app/constants.dart';
import 'package:ehatid_passenger_app/Screens/Home/homescreen.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:ehatid_passenger_app/navigation.dart';
import 'package:ehatid_passenger_app/test_map.dart';
import 'package:ehatid_passenger_app/testing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            backgroundColor: Color(0xFFFED90F),
          ),
          //home: IntroSliderPage(),
          initialRoute: initScreen == 0 ? 'introslider' : 'homepage',
          // paltan ang login ng homepage
          routes: {
            'homepage': (context) => MapSample(),
            'introslider': (context) => MapSample(),
          },
        );
      },
    );
  }
}
