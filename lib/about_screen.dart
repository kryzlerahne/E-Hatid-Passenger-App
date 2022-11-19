import 'package:audioplayers/audioplayers.dart';
import 'package:ehatid_passenger_app/AssignedDriverWidget.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Login/sign_in.dart';
import 'terms_and_conditions.dart';
import 'tripInvoice.dart';
import 'trips_history_screen.dart';
import 'view_profile.dart';

class FAQScreen extends StatefulWidget
{
  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen>
{

  final dbRef = FirebaseDatabase.instance
      .ref()
      .child("passenger")
      .child(fAuth.currentUser!.uid);

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
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text(
          "FAQs",
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
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context, rootNavigator:
                      true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          TripsHistoryScreen()), (route) => false);
                    },
                    leading: Icon(
                      Icons.question_answer_outlined,
                      color: Color(0xff646262),
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Color(0xff646262),
                    ),
                  ),
                  ListTile(
                    title: new Text("FAQ",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xFFFED90F), letterSpacing: -0.5, fontWeight: FontWeight.w400
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
                      color: Color(0xFFFED90F),
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Color(0xFFFED90F),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: <Widget>[ 
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Image.asset("assets/images/faqheader.png")),
                Positioned(
                  top: 50,
                  left: 50,
                  right: 50,
                  bottom: 50,
                  child:
                  Text("Frequently Asked\n Questions",
                    style:TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                ),
                ),
              ],
            ),
            //SizedBox(height: 0.5.h,),
            ExpansionTile(
              title: Text("Who can use E-Hatid?",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                ),
              ),
              leading: Icon(Icons.question_answer,),
              iconColor: Color(0xff646262),
              collapsedBackgroundColor: Color(0xFFFFEE95),
              backgroundColor: Color(0XFFFFEA7A),
              children: [
                ListTile(
                  title: Text("The passengers that are using the TODA G5 Terminal in Lourdes Subdivision"
                      " such as those living in Barangay Bolbok and Banaba can register and access the E-Hatid Application.\n",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff646262), letterSpacing: -0.5
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.2.h,),
            ExpansionTile(
              title: Text("What is E-Hatid?",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                ),
              ),
              leading: Icon(Icons.question_answer),
              collapsedBackgroundColor: Color(0xFFFFEE95),
              iconColor: Color(0xff646262),
              backgroundColor: Color(0XFFFFEA7A),
              children: [
                ListTile(
                  title: Text("E-Hatid is an Android-based booking application for tricycle booking that helps stray drivers and passengers that does not"
                      " have easy and fast access to the main road and terminal.\n",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff646262), letterSpacing: -0.5
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.2.h,),
            ExpansionTile(
              title: Text("Can I use E-Hatid anywhere?",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                ),
              ),
              leading: Icon(Icons.question_answer),
              collapsedBackgroundColor: Color(0xFFFFEE95),
              iconColor: Color(0xff646262),
              backgroundColor: Color(0XFFFFEA7A),
              children: [
                ListTile(
                  title: Text("You can only use E-Hatid App within the routes of the tricycle drivers in TODA G5 in Lourdes terminal.\n",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff646262), letterSpacing: -0.5
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.2.h,),
            ExpansionTile(
              title: Text("How do I install E-Hatid?",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                ),
              ),
              leading: Icon(Icons.question_answer),
              collapsedBackgroundColor: Color(0xFFFFEE95),
              iconColor: Color(0xff646262),
              backgroundColor: Color(0XFFFFEA7A),
              children: [
                ListTile(
                  title: Text("To install E-Hatid, a downloadable file will be disseminated provided by the researchers.\n",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff646262), letterSpacing: -0.5
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.2.h,),
            ExpansionTile(
              title: Text("I have encountered issues. Who can I contact?",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                ),
              ),
              leading: Icon(Icons.question_answer),
              collapsedBackgroundColor: Color(0xFFFFEE95),
              iconColor: Color(0xff646262),
              backgroundColor: Color(0XFFFFEA7A),
              children: [
                ListTile(
                  title: Text("You can directly contact the person in charge or the system administrator situated in the Lourdes terminal and ask for their assitance.\n",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff646262), letterSpacing: -0.5
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.2.h,),
            ExpansionTile(
              title: Text("What is life points?",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                ),
              ),
              leading: Icon(Icons.question_answer),
              collapsedBackgroundColor: Color(0xFFFFEE95),
              backgroundColor: Color(0XFFFFEA7A),
              iconColor: Color(0xff646262),
              children: [
                ListTile(
                  title: Text("Upon registration, users will be given out three (3) life points for free. For every cancellation, one life point is automatically detected"
                      " , and once you ran out of these, you will be suspended for using the application.\n",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff646262), letterSpacing: -0.5
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.2.h,),
            ExpansionTile(
              title: Text("How to top-up life points?",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                ),
              ),
              leading: Icon(Icons.question_answer),
              collapsedBackgroundColor: Color(0xFFFFEE95),
              iconColor: Color(0xff646262),
              backgroundColor: Color(0XFFFFEA7A),
              children: [
                ListTile(
                  title: Text("If the user has ran out of life points, they can go directly in the TODA Terminal"
                      " and pay for loading and top up points to get an access to their accounts.\n ",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff646262), letterSpacing: -0.5
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.2.h,),
            ExpansionTile(
              title: Text("Is it okay to cancel my booking?",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                ),
              ),
              leading: Icon(Icons.question_answer),
              collapsedBackgroundColor: Color(0xFFFFEE95),
              iconColor: Color(0xff646262),
              backgroundColor: Color(0XFFFFEA7A),
              children: [
                ListTile(
                  title: Text("If really necessary yes, but this automatically deduct your life points that will distinguish the access to your account. "
                      "However, it is not recommended to cancel bookings as this will give inconvenience to the hardworking tricycle drivers.\n",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff646262), letterSpacing: -0.5
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h,),
            Column(
              children: [
                Text("E-Hatid. Copyright © 2022. All Rights Reserved. | ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Montserrat', fontSize: 12, color: Color(0xff646262), letterSpacing: -0.5,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext c)
                        {
                          return PrivacyNotice();
                        }
                    );
                  },
                  child: Text("Terms and Conditions ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat', fontSize: 12, color: Color(0xff646262), letterSpacing: -0.5, decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h,),
            // StreamBuilder(
            //   stream: dbRef.onValue,
            //   builder: (context, snapshot)
            //   {
            //     if (snapshot.hasData) {
            //       return Text(snapshot.data['first_name']);
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
