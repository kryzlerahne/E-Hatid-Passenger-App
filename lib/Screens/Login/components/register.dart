import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehatid_passenger_app/Screens/IntroSlider/intro.dart';
import 'package:ehatid_passenger_app/Screens/Login/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Wallet/wallet.dart';

class RegisterPage extends StatefulWidget {
  // final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final FirebaseAuth fAuth = FirebaseAuth.instance;
  User? currentFirebaseUser;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  @override

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Processing, Please wait...",);
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
        "last_name": _firstNameController.text.trim(),
        "email": _emailController.text.trim(),
        "username": _userNameController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("passengers");
      driversRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      Navigator.push(context, MaterialPageRoute(builder: (c)=> Wallet()));
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future addUserDetails(String firstName, String lastName, String email, String username, String password) async {
    await FirebaseFirestore.instance.collection('drivers').add({
      'first_name': firstName,
      'last_name': lastName,
      'email' : email,
      'username' : username,
      'password' : password,

    });
  }


  final formkey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _isHidden2 = true;

  //final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: Form(
        key: formkey,
        child: Center(
          child: Container(
            height: size.height,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create your account",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, letterSpacing: -2, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Adaptive.h(8)),
                  Text(
                    "Please complete the following details.", textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFED90F),),
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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFED90F),),
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
                      validator: (value) {
                        if(value!.isEmpty){
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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFED90F),),
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
                      obscureText: _isHidden2,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFED90F),),
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
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: MaterialButton(
                      onPressed: (){
                          signUp();
                      },
                      color: Color(0xFFFED90F),
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
                          decoration: TextDecoration.underline, color:Color(0xFFFEDF3F),
                        ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }
}
