import 'package:ehatid_passenger_app/Screens/IntroSlider/components/home_bg.dart';
import 'package:ehatid_passenger_app/Screens/Registration/sign_up.dart';
import 'package:ehatid_passenger_app/Screens/Wallet/wallet.dart';
import 'package:ehatid_passenger_app/navigation.dart';
import 'package:ehatid_passenger_app/test_map.dart';
import 'package:ehatid_passenger_app/testing_page.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<Slide> slides = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slides.add(
      new Slide(
        title: "Book A Ride",
        description: "Request a ride and get picked up by \n the nearest tricycle driver around you.",
        pathImage: "assets/images/nearest.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Convenient",
        description: "Your tricycle ride is just one tap away.",
        pathImage: "assets/images/tap.png",
      ),
    );
    slides.add(
      new Slide(
        title: "#1 Mobile-based app for tricycle booking",
        description: "Find and book your tricycle ride from Lourdes Terminal and get traveling.",
        pathImage: "assets/images/ehatid logo.png",
      ),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: EdgeInsets.only(bottom: 10, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    currentSlide.pathImage.toString(),
                    matchTextDirection: true,
                    width: Adaptive.h(50),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    currentSlide.title.toString(),
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 30, letterSpacing: -2, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  child: Text(
                    currentSlide.description.toString(),
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: EdgeInsets.only(
                    top: 15,
                    left: 20,
                    right: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return HomeBackground(
      child: IntroSlider(
        //backgroundColorAllSlides: Colors.yellow,
        renderSkipBtn: Text(
          "Skip",
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: Color(0xff8C8C8C)),
        ),
        renderNextBtn: Text(
          "Next",
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: Colors.white),
        ),
        renderDoneBtn: Text(
          "Done",
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: Colors.white),
        ),
        colorDot: Colors.white,
        sizeDot: 10.0,
        typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
        listCustomTabs: this.renderListCustomTabs(),
        scrollPhysics: BouncingScrollPhysics(),
        onDonePress: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SignUp(),
          ),
        ),
      ),
    );
  }
}