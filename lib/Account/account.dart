import 'package:ehatid_passenger_app/global.dart';
import 'package:ehatid_passenger_app/view_profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'components/accountBody.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  late DatabaseReference dbRef;

  bool isObscurePassword = true;
  
  @override
  void initState(){
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("passengers");
    getPassengerData();
  }
  
  void getPassengerData() async 
  {
    DataSnapshot snapshot = await dbRef.child(widget.userId).get();

    Map passenger = snapshot.value as Map;

    _firstNameController.text = passenger['first_name'];
    _emailController.text = passenger['email'];
    _passwordController.text = passenger['password'];
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
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
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2021/12/29/18/28/animal-6902459_1280.jpg'))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
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
                  hintText: "Enter your name",
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      //fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
          ),
              buildTextField("Email", userModelCurrentInfo!.email!, false),
              buildTextField("Contact Number", "09127890912", false),
              buildTextField("Password", userModelCurrentInfo!.password!, true),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
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
                    SizedBox(width: 7.w),
                    MaterialButton(
                      onPressed: () {},
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(
    String labelText, String placeholder, bool isPasswordTextField) {
  return Padding(
    padding: EdgeInsets.only(bottom: 2.h),
    child: TextField(
      obscureText: isPasswordTextField ? true : false,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFED90F)),
          ),
          labelText: labelText,
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
          hintText: placeholder,
          hintStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
              //fontWeight: FontWeight.bold,
              color: Colors.grey)),
    ),
  );
}
