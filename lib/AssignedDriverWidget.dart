import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/confirmCancellation.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/trips_history_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:supercharged/supercharged.dart';

class AssignedDriverWidget extends StatefulWidget {


  TripsHistoryModel? tripsHistoryModel;

  AssignedDriverWidget({this.tripsHistoryModel});

  @override
  State<AssignedDriverWidget> createState() => _AssignedDriverWidgetState();
}

class _AssignedDriverWidgetState extends State<AssignedDriverWidget> {

  double driverRatings=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDriverRatings();
  }

  getDriverRatings()
  {
    setState(() {
      driverRatings = double.parse(Provider.of<AppInfo>(context, listen: false).driverRates);
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19)
      ),
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  height: 7.h,
                  decoration: BoxDecoration(
                    color: Color(0XFF0CBB8A),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 23.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 2.h,),
                      Text(
                        "Yay! We found you a driver.",
                        style:TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3.5.h,),
                      Container(
                        height: 10.h,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: AssetImage("assets/images/machu.jpg"),
                        ),
                      ),
                      SizedBox(height: 2.h,),
                      Text(
                        driverName,
                        style:TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SmoothStarRating(
                        rating: ratingDriver,
                        allowHalfRating: true,
                        starCount: 5,
                        color: Color(0xFFFED90F),
                        borderColor: Color(0xFFFED90F),
                        size: 23,
                      ),
                      SizedBox(height: 0.5.h,),
                      Text("Tricycle Plate Number: " + driverTricDetails,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h,),
                      Text("Php " + fareAmount,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 11.h,),
                MaterialButton(
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(30),
                  child: Text("Let's go!", style: TextStyle( color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),),
                  color: Color(0XFF0CBB8A),
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}
