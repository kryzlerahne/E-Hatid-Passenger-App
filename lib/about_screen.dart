import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AboutScreen extends StatefulWidget
{
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}




class _AboutScreenState extends State<AboutScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBE5D8),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text(
          "Trips History",
          style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(

        children: [
          SizedBox(height: Adaptive.h(5),),

          //image logo of EHatid
          Container(
            height: Adaptive.h(10),
            child: Center(
              child: Image.asset(
                "assets/images/ehatid logo1.png",
              ),
            ),
          ),
          
          //company name
          Column(
            //company name
            children: [
              Text(
                "E-Hatid",
                style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: Adaptive.h(5),),

              //about the company
              Text(
                "This is an Android-based booking application for tricycle "
                "drivers in TODA G5 in Lourdes Terminal in Bolbok, Batangas City",
                textAlign: TextAlign.center,
                style:TextStyle(fontFamily: 'Montserrat'),
              ),

              SizedBox(height: Adaptive.h(5),),

              //close button
              ElevatedButton(
                onPressed: ()
                {
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white54,
                ),
                child: Text(
                  "Close",
                  style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )



        ],

      ),
    );
  }
}
