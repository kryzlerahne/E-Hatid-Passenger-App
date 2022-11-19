import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/history_design_ui.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:ehatid_passenger_app/tripInvoice.dart';
import 'package:ehatid_passenger_app/view_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Login/sign_in.dart';
import 'about_screen.dart';

class TripsHistoryScreen extends StatefulWidget
{
  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {

  @override
  void dispose() {
    super.dispose();
    Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.clear();
    //allTripsHistoryInformationList = [];
  }

  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          SignIn()), (Route<dynamic> route) => false);
    } catch (e) {
      print(e.toString()) ;
    }
  }

  @override
  Widget build(BuildContext context)
  {

    Size size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser!;

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
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFFFED90F),
                    ),
                    accountName: userModelCurrentInfo!.first_name !=null && userModelCurrentInfo!.last_name !=null ?
                    new Text(userModelCurrentInfo!.first_name! + " " + userModelCurrentInfo!.last_name!,
                      style: TextStyle( color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,),
                    ):new Text(''),// added null condition here,
                    accountEmail: new Text(user.email!,
                      style: TextStyle( color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,),
                    ),
                    currentAccountPicture: new CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("assets/images/icon.png"),
                    ),
                  ),
                  ListTile(
                    title: new Text("Home",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context, rootNavigator:
                      true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          MapSample()), (route) => false);
                    },
                    leading: Icon(
                      Icons.home,
                      color: Color(0xff646262),
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Color(0xff646262),
                    ),
                  ),
                  ListTile(
                    title: new Text("Visit Profile",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context, rootNavigator:
                      true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          ViewProfile()), (route) => false);
                    },
                    leading: Icon(
                      Icons.account_circle_sharp,
                      color: Color(0xff646262),
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Color(0xff646262),
                    ),
                  ),
                  ListTile(
                    title: new Text("History",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xFFFED90F), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context, rootNavigator:
                      true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          TripsHistoryScreen()), (route) => false);
                    },
                    leading: Icon(
                      Icons.question_answer_outlined,
                      color: Color(0xFFFED90F),
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Color(0xFFFED90F),
                    ),
                  ),
                  ListTile(
                    title: new Text("FAQ",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: ()
                    {
                      Navigator.of(context, rootNavigator:
                      true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          FAQScreen()), (route) => false);
                    },
                    leading: Icon(
                      Icons.info_outline_rounded,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            ListTile(
                              title: Text("Sign Out",
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w400
                                ),
                              ),
                              onTap: () async => await _signOut(),
                              leading: Icon(
                                Icons.logout,
                              ),
                              trailing: Icon(
                                Icons.arrow_right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body:  Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Image.asset("assets/images/Vector 11.png",
              width: size.width,
            ),
          ),
          Positioned(
            child: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length == 0
              ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/history.png",
                  width: size.width,
                ),
                Text("You haven't booked your first tricycle ride yet.",
                  style: TextStyle(fontFamily: 'Montserrat', color: Color(0XFF353535)),),
              ],
            )
              : ListView.separated(
            separatorBuilder: (context, i)=> Divider(
              color: Colors.transparent,
              thickness: 2,
              height: 0.5.h,
            ),
            itemBuilder: (context, i)
            {
              return Card(
                color: Colors.white54,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: HistoryDesignUIWidget(
                  tripsHistoryModel: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList[i],
                ),
              );
            },
            itemCount: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
          ),)
        ],
      ),


    );
  }
}
