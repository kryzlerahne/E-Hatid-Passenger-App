import 'package:ehatid_passenger_app/cancellation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class tripInvoice extends StatefulWidget {
  const tripInvoice({Key? key}) : super(key: key);

  @override
  State<tripInvoice> createState() => _tripInvoiceState();
}

class _tripInvoiceState extends State<tripInvoice> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),

      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
           Container(
              height: size.height,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top:-70,
                    left: 0,
                    child: Image.asset("assets/images/Vector 2.png",
                      width: size.width,
                    ),
                  ),
                ],
              ),
            ),
              Container(
                child: Positioned(
                  top: 30,
                  child: Image.asset("assets/images/BgTrip.png",
                      width: Adaptive.w(100),
                      height: Adaptive.h(80),
                  ),
                ),
                ),

              Positioned(

                top: Adaptive.h(20),
                left: Adaptive.w(15),
                child: Center(
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: <Widget> [
                            Text("Summary Details",
                              style: TextStyle(fontFamily: 'Montserrat',
                                letterSpacing: -1.09766, fontSize: Adaptive.sp(20), fontWeight: FontWeight.w700, color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: Adaptive.w(12),),
                            Text("PHP 50.00",
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: Adaptive.sp(17), fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: Adaptive.w(12),),
                          ],
                        ),


                        Row(
                          children: [
                            SizedBox(width: Adaptive.w(5),),
                            Text("September 30, 2022",
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: Adaptive.sp(17),
                              ),
                            ),
                            SizedBox(width: Adaptive.w(5),),
                          ],
                        ),

                        SizedBox(height: 20,),

                        FittedBox(

                          fit: BoxFit.fill,
                          child: Row(
                            children: [
                              SizedBox(width: 2,),
                              Image.asset("assets/images/line.png",
                              height: Adaptive.h(8),

                              ),

                              SizedBox(width: 2,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("7-Eleven, Bolbok, Batangas City",
                                    style: TextStyle(fontFamily: 'Montserrat',),), //PLACE YOUR LOCATION HERE
                                  SizedBox(height: 10,),
                                  Center(
                                    child: Container(
                                      width: 240,
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Adaptive.h(1),),
                                  Text("Sta. Rita de Cascia Parish Church",
                                    style: TextStyle(fontFamily: 'Montserrat'),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Adaptive.h(2.5),),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Column(
                   // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //SizedBox(height: 40,),
                      Row(
                        children: [
                          Text("Booking ID:",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: Adaptive.sp(16),
                            ),
                          ),
                          SizedBox(width: Adaptive.w(32.5),),
                          Text("TD8423",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: Adaptive.sp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Adaptive.h(1),),

                      Row(
                        children: [
                          Text("Tricycle Number:",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: Adaptive.sp(16),
                            ),
                          ),
                          SizedBox(width: Adaptive.w(21),),
                          Text("6398 BX",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: Adaptive.sp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Adaptive.h(1),),

                      Row(
                        children: [
                          Text("Assigned Driver:",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: Adaptive.sp(16),
                            ),
                          ),
                          SizedBox(width: Adaptive.w(12),),
                          Text("Martin Nivera",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: Adaptive.sp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Adaptive.h(1),),

                      Row(
                        children: [
                          Text("Time of Arrival:",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: Adaptive.sp(16),
                            ),
                          ),
                          SizedBox(width: Adaptive.w(27),),
                          Text("4:13 PM",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: Adaptive.sp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Adaptive.h(1),),

                      Row(
                        children: [
                          Text("Total Distance:",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: Adaptive.sp(16),
                            ),
                          ),
                          SizedBox(width: Adaptive.w(31.5),),
                          Text("192m",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: Adaptive.sp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Adaptive.h(1),),

                      Row(
                        children: [
                          Text("Waiting Time:",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: Adaptive.sp(16),
                            ),
                          ),
                          SizedBox(width: Adaptive.w(30),),
                          Text("5 mins",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: Adaptive.sp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Adaptive.h(1),),

                      Row(
                        children: [
                          Text("Estimated Fare:",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: Adaptive.sp(16),
                            ),
                          ),
                          SizedBox(width: Adaptive.w(19.5),),
                          Text("Php 50.00",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: Adaptive.sp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    ),
                    ],
                    ),
                ],
                    ),
              ),
                ),
              ),
              SizedBox(height: Adaptive.h(100),),

              Positioned(
                top:Adaptive.h(74),
                left: Adaptive.w(10),
                child: Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("You can screenshot this page for reference \n upon your driver's arrival.",
                         maxLines: 2,
                        textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontSize: Adaptive.sp(16),

                          ),
                        ),
                        Row(
                          children: [

                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top:Adaptive.h(80),
                left: Adaptive.w(20),
                child: MaterialButton(
                  onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BookingComplete())
                      );},

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(60),
                  child: Text("Done", style: TextStyle( color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),),
                  color: Color(0XFF0CBC8B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

