import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/info_design_ui.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileScreen extends StatefulWidget
{

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBE5D8),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text(
          "My Profile",
          style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: ()
          {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_) => MapSample(),
            ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //display the name
            Text(
              userModelCurrentInfo!.first_name! + userModelCurrentInfo!.last_name!,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontSize: 19.sp,
                  letterSpacing: -1,
                  fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(
              height: Adaptive.h(2),
              width: Adaptive.w(10),
              child: Divider(
                color: Colors.white,
              ),
            ),

            SizedBox(height: Adaptive.h(5),),

            //display phone number
            // InfoDesignUIWidget(
            //   textInfo: userModelCurrentInfo!.phone!,
            //   iconData: Icons.phone,
            // ),

            //display email
            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo!.email!,
              iconData: Icons.email,
            ),

            SizedBox(height: Adaptive.h(2),),

            ElevatedButton(
                onPressed: ()
                {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (_) => MapSample(),
                  ),
                  );
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
        ),
      ),
    );
  }
}
