import 'package:ehatid_passenger_app/assistant_methods.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget
{

  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  State<SelectNearestActiveDriversScreen> createState() => _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState extends State<SelectNearestActiveDriversScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          "Nearest Online Drivers",
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: 19.sp,
            letterSpacing: -0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 26.sp,
            color: Color(0xFF777777),
          ),
          onPressed: ()
          {
            //delete or remove ride request from database
            widget.referenceRideRequest!.remove();
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index)
        {
          return Card(
            color: Colors.grey,
            elevation: 3,
            shadowColor: Colors.green,
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 26.sp,
                  color: Color(0xFF777777),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    dList[index]["first_name"],
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.sp,
                      color: Color(0xFF272727),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SmoothStarRating(
                    rating: 3.5,
                    color: Colors.black,
                    borderColor: Colors.black,
                    allowHalfRating: true,
                    starCount: 5,
                    size: 15,
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.duration_text! : "",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.sp,
                      color: Color(0xFF272727),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h,),
                  Text(
                    //tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.duration_text! : "",
                    //"",
                    AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!).toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.sp,
                      color: Color(0xFF272727),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/**class ActiveDriver extends StatefulWidget {
  const ActiveDriver({Key? key}) : super(key: key);

  @override
  State<ActiveDriver> createState() => _ActiveDriverState();
}

class _ActiveDriverState extends State<ActiveDriver> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19)
        ),
        child: Container(
          height: 45.h,
          width: 150.w,
          child: Column(
            children: [
              Container(
                height: 8.5.h,
                decoration: BoxDecoration(
                  color: Color(0XFF0CBB8A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Passengers Near You",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 19.sp,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dList.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                    return Card(
                      color: Colors.grey,
                      elevation: 3,
                      shadowColor: Colors.green,
                      margin: EdgeInsets.all(8),
                        child: ListTile(
                          leading:Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 26.sp,
                              color: Color(0xFF777777),
                            ),
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                dList[index]["name"],
                              ),
                            ],
                          ),
                        ),
                    );
                  },
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                minWidth: Adaptive.w(40),
                child: Text("Cancel", style: TextStyle( color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,),),
                color: Color(0XFF0CBC8B),
                onPressed: () async
                {
                  //remove or delete the ride request from the database
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        )
    );
  }
}
**/