import 'dart:async';

import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:ehatid_passenger_app/processing_dialog.dart';
import 'package:ehatid_passenger_app/view_profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdateRecord extends StatefulWidget {
  const UpdateRecord({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {

  late DatabaseReference dbRef;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();

  bool _isHidden = true;

  late FocusNode focusFname;
  late FocusNode focusLname;
  late FocusNode focusEmail;
  late FocusNode focusUsername;
  late FocusNode focusPass;
  late FocusNode focusPhone;
  late FocusNode focusBirth;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("passengers");
    getPassengerData();

    focusFname = FocusNode();
    focusLname = FocusNode();
    focusEmail = FocusNode();
    focusBirth = FocusNode();
    focusUsername = FocusNode();
    focusPass = FocusNode();
    focusPhone = FocusNode();
    focusBirth = FocusNode();
  }

  void getPassengerData() async
  {
    DataSnapshot snapshot = await dbRef.child(widget.userId).get();

    Map passenger = snapshot.value as Map;

    _firstNameController.text = passenger['first_name'];
    _lastNameController.text = passenger['last_name'];
    _emailController.text = passenger['email'];
    _userNameController.text = passenger['username'];
    _passwordController.text = passenger['password'];
    _phoneController.text = passenger['phoneNum'];
    _birthdateController.text = passenger['birthdate'];
  }

  validateForm() {
    if (_firstNameController.text == null ||
        _firstNameController.text.isEmpty) {
      focusFname.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your first name.");
    }

    else
    if (_lastNameController.text == null || _lastNameController.text.isEmpty) {
      focusLname.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your last name.");
    }

    else if (_birthdateController.text == null ||
        _birthdateController.text.isEmpty) {
      focusBirth.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your birthday.");
    }

    else if (_phoneController.text == null || _phoneController.text.isEmpty) {
      focusPhone.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your phone number.");
    }

    else if (_phoneController.text.length != 11) {
      focusPhone.requestFocus();
      Fluttertoast.showToast(msg: "Invalid phone number.");
    }

    else
    if (_emailController.text != null && !_emailController.text.contains("@")) {
      focusEmail.requestFocus();
      Fluttertoast.showToast(msg: "Please enter a valid email.");
    }

    else
    if (_userNameController.text == null || _userNameController.text.isEmpty) {
      focusUsername.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your username.");
    }

    else if (_userNameController.text.length < 4) {
      focusUsername.requestFocus();
      Fluttertoast.showToast(
          msg: "Choose a username with 4 or more characters.");
    }

    else if (_passwordController.text.isEmpty) {
      focusPass.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your password.");
    }

    else if (_passwordController.text.length < 8) {
      focusPass.requestFocus();
      Fluttertoast.showToast(msg: "Password must be atleast 8 Characters.");
    }
    else {
      update();
    }
  }

  Future update() async
  {
    Map<String, String> passenger = {
      "first_name": _firstNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "email": _emailController.text.trim(),
      "username": _userNameController.text.trim(),
      "password": _passwordController.text.trim(),
      "phoneNum": _phoneController.text.trim(),
    };

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProcessingBookingDialog(message: "Updating, Please wait...",);
        }
    );

    Timer(const Duration(seconds: 2), () {
      dbRef.child(widget.userId).update(passenger)
          .then((value) =>
      {

        Fluttertoast.showToast(msg: "Updated Successfully."),

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => ViewProfile(),
        ),
        ),
      });
    });
  }

  @override
  void dispose() {
    focusFname.dispose();
    focusLname.dispose();
    focusPhone.dispose();
    focusBirth.dispose();
    focusEmail.dispose();
    focusUsername.dispose();
    focusPass.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text('Edit My Profile',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image.asset("assets/images/Vector 3.png",
              width: size.width,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, top: 20, right: 15),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  SizedBox(height: Adaptive.h(0.5)),
                  Center(
                    child: Stack(
                      children: [
                        Container(
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
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 4, color: Colors.white),
                                  color: Color(0xFFFED90F)),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: Adaptive.h(.5)),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: TextField(
                      controller: _firstNameController,
                      focusNode: focusFname,
                      obscureText: false,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFED90F)),
                          ),
                          labelText: "First Name",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFFFED90F),
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your first name",
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: TextField(
                      controller: _lastNameController,
                      focusNode: focusLname,
                      obscureText: false,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFED90F)),
                          ),
                          labelText: "Last Name",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFFFED90F),
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your last name",
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: TextField(
                      controller: _emailController,
                      focusNode: focusEmail,
                      obscureText: false,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFED90F)),
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFFFED90F),
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your email",
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: TextField(
                      controller: _userNameController,
                      focusNode: focusUsername,
                      obscureText: false,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFED90F)),
                          ),
                          labelText: "Username",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFFFED90F),
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your username",
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: TextField(
                      controller: _passwordController,
                      focusNode: focusPass,
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFED90F)),
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFFFED90F),
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your password",
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                              _isHidden ? Icons.visibility : Icons
                                  .visibility_off,
                              color: Color(0xffCCCCCC),
                            ),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: TextField(
                      controller: _phoneController,
                      focusNode: focusPhone,
                      obscureText: false,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFED90F)),
                          ),
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFFFED90F),
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your phone number",
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              //fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                    ),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            validateForm();
                          },
                          minWidth: Adaptive.w(40),
                          child: Text("Save",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          color: Color(0xFF0CBC8B),
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        SizedBox(width: 7.w),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (_) => ViewProfile(),
                            ),
                            );
                          },
                          minWidth: Adaptive.w(40),
                          child: Text("Cancel",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          color: Color(0XFFC5331E),
                          //padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
