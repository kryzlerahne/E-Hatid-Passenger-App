import 'package:ehatid_passenger_app/Screens/IntroSlider/components/intro_slider.dart';
import 'package:ehatid_passenger_app/Screens/IntroSlider/intro.dart';
import 'package:ehatid_passenger_app/Screens/Welcome/welcome_screen.dart';
import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/assistant_methods.dart';
import 'package:ehatid_passenger_app/constants.dart';
import 'package:ehatid_passenger_app/Screens/Home/homescreen.dart';
import 'package:ehatid_passenger_app/main_page.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:ehatid_passenger_app/navigation.dart';
import 'package:ehatid_passenger_app/test_map.dart';
import 'package:ehatid_passenger_app/testing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'assistant_methods.dart';

int initScreen = 0;

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var result = await preferences.getInt('initScreen');
  if(result != null){
    initScreen = result;
  }

  await Firebase.initializeApp();
  runApp(
    RestartWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();

    AssistantMethods.readCurrentOnlineUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return ChangeNotifierProvider(
          create: (context) => AppInfo(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              backgroundColor: Color(0xFFFED90F),
            ),
            //home: IntroSliderPage(),
            initialRoute: initScreen == 0 ? 'introslider' : 'homepage',
            // paltan ang login ng homepage
            routes: {
              'homepage': (context) => MapSample(),
              'introslider': (context) => MainPage(),
            },
          ),
        );
      },
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }


  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child ?? Container(),
    );
  }
}

