import 'package:ehatid_passenger_app/Account/account.dart';
import 'package:ehatid_passenger_app/Screens/Login/sign_in.dart';
import 'package:ehatid_passenger_app/about_screen.dart';
import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:ehatid_passenger_app/tripInvoice.dart';
import 'package:ehatid_passenger_app/trips_history_screen.dart';
import 'package:ehatid_passenger_app/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'global.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {

  double finalLife=0;

  final user = FirebaseAuth.instance.currentUser!;

  late final dbRef = FirebaseDatabase.instance.reference();
  late DatabaseReference databaseReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLifePoints();
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

  getLifePoints()
  {
    setState(() {
      finalLife = double.parse(Provider.of<AppInfo>(context, listen: false).finalLifePoints);
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text('My Profile',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold)),
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
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xFFFED90F), letterSpacing: -0.5, fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context, rootNavigator:
                      true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          ViewProfile()), (route) => false);
                    },
                    leading: Icon(
                      Icons.account_circle_sharp,
                      color: Color(0xFFFED90F),
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Color(0xFFFED90F),
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
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
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
      body: Stack(
        children: <Widget> [
          Container(
          //padding: EdgeInsets.only(left: 15, top: 0, right: 15),
          child: Center(
            child: Stack(
              children: [
                Container(
                  height: size.height,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        child: Image.asset("assets/images/Vector 3.png",
                          width: size.width,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          width: 30.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                              //border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage("assets/images/icon.png"))),
                        ),
                        RatingBar(
                          initialRating: finalLife,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 3,
                          itemSize: 5.w,
                          ratingWidget: RatingWidget(
                            full: Image.asset("assets/images/heart.png", color: Color(0xFFE98862)),
                            half: Image.asset("assets/images/heart_half.png", color: Color(0xFFE98862)),
                            empty: Image.asset("assets/images/heart_border.png", color: Color(0xFFE98862)),
                          ),
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userModelCurrentInfo!.first_name!+ " " + userModelCurrentInfo!.last_name!,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontSize: 19.sp,
                                  letterSpacing: -1,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(width: 0.5.w,),
                            Icon(Icons.verified_rounded,
                              color: Color(0xFF0CBC8B),),
                          ],
                        ),
                        Text("Username: @" + userModelCurrentInfo!.username!,
                          style: TextStyle(
                              fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff7D7D7D), letterSpacing: -0.5, fontWeight: FontWeight.w400
                          ),
                        ),
                        SizedBox(height: 5.h,),
                        Card(
                          elevation: 3, // the size of the shadow
                          color: Color(0XFFFFEE95),
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              width: 75.w,
                              height: 8.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.email,  color: Color(0xFFFED90F)),
                                  SizedBox(width: 2.w,),
                                  Row(
                                    children: [
                                      Text(
                                        "Email: ",
                                        //overflow: TextOverflow.ellipsis,
                                        style: TextStyle( color: Color(0xbc000000),
                                          fontSize: 13,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400,),
                                      ),
                                      Container(
                                        width: Adaptive.w(50),
                                        child: Text(
                                          userModelCurrentInfo!.email!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle( color: Color(0xbc000000),
                                            fontSize: 13,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w400,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h,),
                        Card(
                          elevation: 3, // the size of the shadow
                          color: Color(0XFFFFEE95),
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              width: 75.w,
                              height: 8.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone_android,  color: Color(0xFFFED90F)),
                                  SizedBox(width: 2.w,),
                                  Text(
                                    "Phone: " + userModelCurrentInfo!.phoneNum!,
                                    style: TextStyle( color: Color(0xbc000000),
                                      fontSize: 13,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h,),
                        Card(
                          elevation: 3, // the size of the shadow
                          color: Color(0XFFFFEE95),
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              width: 75.w,
                              height: 8.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_month,  color: Color(0xFFFED90F)),
                                  SizedBox(width: 2.w,),
                                  Text(
                                    "Birthdate: " + userModelCurrentInfo!.birthDate!,
                                    style: TextStyle( color: Color(0xbc000000),
                                      fontSize: 13,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  minWidth: Adaptive.w(40),
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit,  color: Color(0xFFFFFCEA)),
                                      SizedBox(width: 2.w,),
                                      Text("Edit Profile", style: TextStyle( color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,),),
                                    ],
                                  ),
                                  color:Color(0XFF63B389),
                                  onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                    builder: (_) => UpdateRecord(userId: userModelCurrentInfo!.id!),
                                      ),
                                    );
                                  }
                                ),
                                SizedBox(width: 1.w,),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  minWidth: Adaptive.w(40),
                                  child: Row(
                                    children: [
                                      Icon(Icons.exit_to_app,  color: Color(0xFFFFFCEA)),
                                      SizedBox(width: 2.w,),
                                      Text("Sign out", style: TextStyle( color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,),),
                                    ],
                                  ),
                                  color:Color(0XFFCD4C3A),
                                  onPressed: () async => await _signOut(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
