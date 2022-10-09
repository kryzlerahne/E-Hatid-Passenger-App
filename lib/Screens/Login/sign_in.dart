import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehatid_passenger_app/Screens/IntroSlider/intro.dart';
import 'package:ehatid_passenger_app/Screens/Login/components/forget_pw.dart';
import 'package:ehatid_passenger_app/Screens/Home/homescreen.dart';
import 'package:ehatid_passenger_app/Screens/Login/components/register.dart';
import 'package:ehatid_passenger_app/main_page.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ehatid_passenger_app/Screens/Registration/sign_up.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth fAuth = FirebaseAuth.instance;
  User? currentFirebaseUser;

  Future signIn() async {
    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    if(firebaseUser != null)
    {
      DatabaseReference passengersRef = FirebaseDatabase.instance.ref().child("passengers");
      passengersRef.child(firebaseUser.uid).once().then((passengersKey)
      {
        final snap = passengersKey.snapshot;
        if(snap.value != null)
        {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          Timer(const Duration(seconds: 3),(){
            Navigator.push(context, MaterialPageRoute(builder: (c)=>  MapSample()));
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "No record exist with this email.");
          //fAuth.signOut();
          //Navigator.push(context, MaterialPageRoute(builder: (c)=>  SignUp()));
        }
      });
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login.");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final formkey = GlobalKey<FormState>();
  bool _isHidden = true;

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
                      top: 0,
                      child: Image.asset("assets/images/Vector 2.png",
                        width: size.width,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/loginLogo.png",
                          width: 250
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Sign in to your account",
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, letterSpacing: -2, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Welcome Back! Ready for your next ride?", textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFED90F),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Email",
                            prefixIcon: Icon(Icons.person, color: Color(0xffCCCCCC)),
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(height:10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFED90F),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock, color: Color(0xffCCCCCC)),
                            suffixIcon: InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(
                                _isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xffCCCCCC),
                              ),
                            ),
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return ForgotPasswordPage();
                                },
                                ),
                                );
                              },
                              child: Text("Forgot Password?", style: TextStyle(fontFamily: 'Montserrat', fontSize: 14,
                                letterSpacing: -0.5, fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline, color:Color(0xFFFEDF3F),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: MaterialButton(
                          onPressed: signIn,
                          color: Color(0xFFFED90F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          minWidth: double.infinity,
                          child: Text("Sign in",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account yet?", style: TextStyle(
                                color: Color(0xFF494949), fontFamily: 'Montserrat', fontSize: 15, letterSpacing: -0.5, fontWeight: FontWeight.w500
                            ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (_) => RegisterPage(),
                                ),
                                );
                              },
                              child: Text("Register", style: TextStyle(fontFamily: 'Montserrat', fontSize: 16,
                                letterSpacing: -0.5, fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline, color:Color(0xFFFEDF3F),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}


class ProgressDialog extends StatelessWidget
{
  String? message;
  ProgressDialog({this.message});


  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [

              const SizedBox(width: 6.0,),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),

              const SizedBox(width: 26.0,),

              Text(
                message!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
