import 'package:animate_do/animate_do.dart';
import 'package:ehatid_passenger_app/Screens/Login/components/register.dart';
import 'package:ehatid_passenger_app/Screens/OTP/otp_verification.dart';
import 'package:ehatid_passenger_app/main_page.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController phoneController = TextEditingController();

  String dialCodeDigits = "+63";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    //total height and width
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(height: 100,),
              Positioned(
                top: 0,
                child: Image.asset(
                  "assets/images/vector_top.png",
                  width: size.width,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/vector_bottom.png",
                  width: size.width,
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(30, 60, 30, 0),
                  child: Column(
                    children: [
                      Image.asset("assets/images/regLogo.png",
                        width: 200,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5, top: 10),
                        child: Text(
                          "Sign up to E-Hatid",
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.171875,
                            fontSize: 24.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 32, 32, 32),
                            letterSpacing: -1.6800000000000002,
                          ),
                        ),
                      ),
                      Text(
                        "Book your next tricycle in just one tap.",
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.171875,
                          fontSize: 13,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 39, 39, 39),
                          letterSpacing: -0.48,
                        ),
                      ),
                      FadeInDown(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffeeeeee),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.13))
                            ),
                            child: Stack(
                              children: [
                                InternationalPhoneNumberInput(
                                  onInputChanged: (country) {
                                    setState(() {
                                      dialCodeDigits = country.dialCode!;
                                    });
                                  },
                                  cursorColor: Colors.black,
                                  formatInput: false,
                                  textFieldController: phoneController,
                                  maxLength: 10,
                                  initialValue: PhoneNumber(
                                      isoCode: 'PH', dialCode: '+63'),
                                  selectorConfig: SelectorConfig(
                                      selectorType: PhoneInputSelectorType
                                          .BOTTOM_SHEET
                                  ),
                                  inputDecoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: 15, left: 0),
                                      border: InputBorder.none,
                                      hintText: 'Phone Number',
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontFamily: 'Montserrat',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),/*
                                      prefix: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(dialCodeDigits),
                                      )*/
                                  ),
                                ),
                                Positioned(
                                  left: 85,
                                  top: 8,
                                  bottom: 8,
                                  child: Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.black.withOpacity(0.13),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      FadeInDown(
                        child: MaterialButton(
                          onPressed: (){
                            if(phoneController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Phone number is still empty!")
                                ),
                              );
                            } else if(phoneController.text.length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Invalid phone number!")
                                ),
                              );
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => OtpBody(
                                    phone: phoneController.text,
                                    codeDigits: dialCodeDigits,
                                  )));
                            }
                          },
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                          minWidth: double.infinity,
                          child: Text("Sign up with Phone",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      FadeInDown(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 50, top: 15),
                          child: GestureDetector(
                            child: Text("I have an account already",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                height: 1.171875,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 39, 39, 39),
                                decoration: TextDecoration.underline,
                                letterSpacing: -0.48,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MainPage()
                                  )
                              );
                            },
                          ),
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
}