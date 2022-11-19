import 'package:ehatid_passenger_app/Screens/Login/sign_in.dart';
import 'package:ehatid_passenger_app/about_screen.dart';
import 'package:ehatid_passenger_app/profile_screen.dart';
import 'package:ehatid_passenger_app/trips_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatefulWidget
{

  String? name;
  String? email;

  MyDrawer({this.name, this.email});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}


class _MyDrawerState extends State<MyDrawer>
{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      await _firebaseAuth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => SignIn(),
      ),
      );
    } catch (e) {
      print(e.toString()) ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFFFED90F),
                  ),
                  accountName: new Text(widget.name.toString()),
                  accountEmail: new Text(widget.email.toString()),
                  currentAccountPicture: new CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage("assets/images/machu.jpg"),
                  ),
                ),
                ListTile(
                  title: new Text("Visit Profile"),
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (_) => ProfileScreen(),
                    ),
                    );
                  },
                  leading: Icon(
                    Icons.account_circle_sharp,
                    color: Color(0xFFFED90F),
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                  ),
                ),
                ListTile(
                  title: new Text("History"),
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (_) => TripsHistoryScreen(),
                    ),
                    );
                  },
                  leading: Icon(
                    Icons.question_answer_outlined,
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                  ),
                ),
                ListTile(
                  title: new Text("FAQ"),
                  onTap: ()
                  {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (_) => FAQScreen(),
                    ),
                    );
                  },
                  leading: Icon(
                    Icons.info_outline_rounded,
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                  ),
                ),
                ListTile(
                  title: new Text("Settings"),
                  onTap: (){},
                  leading: Icon(
                    Icons.settings,
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                  ),
                ),
                ListTile(
                  title: new Text("Terms & Conditions"),
                  onTap: (){},
                  leading: Icon(
                    Icons.book,
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
                            title: Text("Sign Out"),
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
    );
  }
}
