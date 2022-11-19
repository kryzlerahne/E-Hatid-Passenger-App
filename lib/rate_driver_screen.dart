import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/main.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RateDriverScreen extends StatefulWidget
{

  String? assignedDriverId;

  RateDriverScreen({this.assignedDriverId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFCEA),
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: Adaptive.h(2),),
              Text("Rate Trip Experience",
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.3.w, fontWeight: FontWeight.w600,),
              ),
              SizedBox(height: Adaptive.h(2),),
              Divider(
                height: 2.h,
                thickness: 4.0,
              ),
              SizedBox(height: Adaptive.h(2),),
              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: true,
                starCount: 5,
                color: Color(0XFF0CBC8B),
                borderColor: Color(0XFF0CBC8B),
                size: 46,
                onRatingChanged: (valueOfStarsChoosed)
                {
                  countRatingStars = valueOfStarsChoosed;

                  if(countRatingStars == 1)
                  {
                    setState(() {
                      titleStarsRating = "Very Bad";
                    });
                  }

                  if(countRatingStars == 2)
                  {
                    setState(() {
                      titleStarsRating = "Bad";
                    });
                  }

                  if(countRatingStars == 3)
                  {
                    setState(() {
                      titleStarsRating = "Good";
                    });
                  }

                  if(countRatingStars == 4)
                  {
                    setState(() {
                      titleStarsRating = "Very Good";
                    });
                  }

                  if(countRatingStars == 5)
                  {
                    setState(() {
                      titleStarsRating = "  Excellent";
                    });
                  }
                },
              ),
              SizedBox(height: Adaptive.h(1),),
              Text(
                titleStarsRating,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.3.w, fontWeight: FontWeight.w600,),
              ),
              SizedBox(height: Adaptive.h(1),),

              MaterialButton(
                onPressed: ()
                {
                  DatabaseReference rateDriverRef = FirebaseDatabase.instance.ref()
                      .child("drivers")
                      .child(widget.assignedDriverId!)
                      .child("ratings");

                  rateDriverRef.once().then((snap)
                  {
                    if(snap.snapshot.value == null)
                    {
                      rateDriverRef.set(countRatingStars.toString());

                      passengerIsOfflineNow();
                      SystemNavigator.pop();
                    }
                    else
                    {
                      double pastRatings = double.parse(snap.snapshot.value.toString());
                      double newAverageRatings = (pastRatings + countRatingStars) / 2;
                      rateDriverRef.set(newAverageRatings.toString());

                      passengerIsOfflineNow();
                      RestartWidget.restartApp(context);
                    }

                    Fluttertoast.showToast(msg: "Please restart the app now.");
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                minWidth: Adaptive.w(40),
                child: Text("Continue", style: TextStyle( color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,),),
                color: Color(0XFF0CBC8B),
              ),
              SizedBox(height: Adaptive.h(1),),
            ],
          ),
        ),
      ),
    );
  }

  passengerIsOfflineNow()
  {
    Geofire.removeLocation(user.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref()
        .child("passenger")
        .child(user.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;
  }
}
