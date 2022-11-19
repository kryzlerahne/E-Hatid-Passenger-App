import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehatid_passenger_app/Screens/IntroSlider/intro.dart';
import 'package:ehatid_passenger_app/Screens/Login/sign_in.dart';
import 'package:ehatid_passenger_app/navigation.dart';
import 'package:ehatid_passenger_app/processing_dialog.dart';
import 'package:ehatid_passenger_app/terms_and_conditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Wallet/wallet.dart';

class RegisterPage extends StatefulWidget {
  // final VoidCallback showLoginPage;

  final String phone;

  RegisterPage({required this.phone});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final FirebaseAuth fAuth = FirebaseAuth.instance;
  User? currentFirebaseUser;
  bool agree = false;

  late FocusNode focusFname;
  late FocusNode focusLname;
  late FocusNode focusPhone;
  late FocusNode focusBirth;
  late FocusNode focusEmail;
  late FocusNode focusUsername;
  late FocusNode focusPass;
  late FocusNode focusConfirmPass;


  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    focusFname = FocusNode();
    focusLname = FocusNode();
    focusPhone = FocusNode();
    focusBirth = FocusNode();
    focusEmail = FocusNode();
    focusUsername = FocusNode();
    focusPass = FocusNode();
    focusConfirmPass = FocusNode();
  }

  validateForm() {
    if(_firstNameController.text == null || _firstNameController.text.isEmpty)
    {
      focusFname.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your first name.");
    }
    else if(_lastNameController.text == null || _lastNameController.text.isEmpty)
    {
      focusLname.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your last name.");
    }
    else if(_birthdateController.text == null || _birthdateController.text.isEmpty)
    {
      focusBirth.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your birthday.");
    }
    else if(_phoneController.text == null || _phoneController.text.isEmpty)
    {
      focusPhone.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your phone number.");
    }
    else if(_phoneController.text.length != 11)
    {
      focusPhone.requestFocus();
      Fluttertoast.showToast(msg: "Invalid phone number.");
    }
    else if(_phoneController.text != widget.phone.toString())
    {
      focusPhone.requestFocus();
      Fluttertoast.showToast(msg: "Phone number does not match.");
    }
    else if(_emailController.text != null && !_emailController.text.contains("@"))
    {
      focusEmail.requestFocus();
      Fluttertoast.showToast(msg: "Enter a valid email.");
    }
    else if (_userNameController.text == null || _userNameController.text.isEmpty)
    {
      focusUsername.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your username.");
    }
    else if (_userNameController.text.length < 4)
    {
      focusUsername.requestFocus();
      Fluttertoast.showToast(msg: "Choose a username with 4 or more characters.");
    }
    else if(_passwordController.text.isEmpty)
    {
      focusPass.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your password.");
    }
    else if(_passwordController.text.length < 8)
    {
      focusPass.requestFocus();
      Fluttertoast.showToast(msg: "Password must be atleast 8 Characters.");
    }
    else if (_confirmpasswordController.text == null || _confirmpasswordController.text.isEmpty)
    {
      focusConfirmPass.requestFocus();
      Fluttertoast.showToast(msg: "Please re-enter your password.");
    }
    else if (_confirmpasswordController.text != _passwordController.text)
    {
      focusConfirmPass.requestFocus();
      Fluttertoast.showToast(msg: "Password mismatch.");
    }
    else if (agree != true)
    {
      Fluttertoast.showToast(msg: "Please read and accept the Terms and Conditions before registration.");
    }
    else
    {
      signUp();
    }
  }

  @override

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProcessingBookingDialog(message: "Processing, Please wait...",);
        }
    );

    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    if(firebaseUser != null)
    {
      Map userMap =
      {
        "id": firebaseUser.uid,
        "first_name": _firstNameController.text.trim(),
        "last_name": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "username": _userNameController.text.trim(),
        "password": _passwordController.text.trim(),
        "phoneNum": _phoneController.text.trim(),
        "birthdate": _birthdateController.text.trim(),
        "lifePoints": 3,
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("passengers");
      driversRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      Timer(const Duration(seconds: 3),(){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> SignIn()));
      });
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
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
    focusConfirmPass.dispose();

    super.dispose();
  }


  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  final formkey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _isHidden2 = true;

  //final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0XFFF8D516),
      body: Stack(
        //alignment: Alignment.center,
        children: <Widget> [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/images/Vector 13.png",
              width: Adaptive.w(40),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset("assets/images/Vector 14.png",
              width: Adaptive.w(80),
            ),
          ),
          Form(
          key: formkey,
          child: Center(
            child: Container(
              height: size.height,
              width: double.infinity,
              child: Stack(
                children: [
                  SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Adaptive.h(2)),
                      Image.asset("assets/images/createAcount.png",
                      width: Adaptive.w(45),),
                      Text(
                        "Create your account",
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, letterSpacing: -2, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: Adaptive.h(0.5)),
                      Text(
                        "Please complete the following details.", textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: Adaptive.h(2),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _firstNameController,
                          focusNode: focusFname,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF272727),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "First Name",
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Please enter your first name.';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _lastNameController,
                          focusNode: focusLname,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF272727),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Last Name",
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (_lastNameController) {
                            if(_lastNameController!.isEmpty){
                              return 'Please enter your last name.';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _phoneController,
                          focusNode: focusPhone,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF272727),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Phone Number",
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Please enter your phone number.';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _birthdateController,
                          focusNode: focusBirth,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF272727),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Birthdate",
                            prefixIcon: Icon(Icons.calendar_month),
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Please enter your birthdate.';
                            } else {
                              return null;
                            }
                          },
                          onTap: () async
                          {
                            DateTime? pickedDate = await showDatePicker(context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2101));

                            if(pickedDate !=null)
                              {
                                setState(() {
                                  _birthdateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _emailController,
                          focusNode: focusEmail,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF272727),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _userNameController,
                          focusNode: focusUsername,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF272727),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Username",
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Please enter your username.';
                            } else if(value.length < 4) {
                              return "Choose a username with 4 or more characters.";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _passwordController,
                          focusNode: focusPass,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF272727),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Password",
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
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Please enter your password.';
                            } else if (value.length < 8) {
                              return "Length of password must be 8 or greater.";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _confirmpasswordController,
                          focusNode: focusConfirmPass,
                          obscureText: _isHidden2,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF272727),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Confirm Password",
                            suffixIcon: InkWell(
                              onTap: _toggleConfirmPasswordView,
                              child: Icon(
                                _isHidden2
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
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Please re-enter your password.';
                            } else if (value.length < 8) {
                              return "Length of password must be 8 or greater.";
                            } else if(value != _passwordController.text) {
                              return "Password mismatch.";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: agree,
                                onChanged: (value) {
                                  setState(() {
                                    agree = value ?? false;
                                  });
                                },
                              ),
                              Column(
                                children: [
                                  Text(
                                  "I have read and accept the ",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
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
                                    child: Text(
                                      "Terms and Conditions of E-Hatid App",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,),
                                    ),
                                  ),
                                ],
                              ),
                          ],),
                        ],
                      ),

                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: MaterialButton(
                          onPressed: (){
                          validateForm();
                          },
                          color: Color(0xFF272727),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          minWidth: double.infinity,
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Montserrat', fontSize: 16
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Have an account already?", style: TextStyle(
                              color: Color(0xFF494949), fontFamily: 'Montserrat', fontSize: 16, letterSpacing: -0.5, fontWeight: FontWeight.w500
                          ),
                          ),
                          TextButton(
                            onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (_) => SignIn(),
                                ),
                                );
                            },
                            child: Text("Login", style: TextStyle(fontFamily: 'Montserrat', fontSize: 16,
                              letterSpacing: -0.5, fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline, color:Color(0xFF494949),
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],),
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

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }
}
