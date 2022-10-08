import 'package:ehatid_passenger_app/Screens/Login/components/register.dart';
import 'package:ehatid_passenger_app/Screens/OTP/otp_verified.dart';
import 'package:ehatid_passenger_app/Screens/Registration/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpBody extends StatefulWidget {
  final String phone;
  final String codeDigits;

  OtpBody({required this.phone, required this.codeDigits});

  @override
  _OtpBodyState createState() => _OtpBodyState();
}

class _OtpBodyState extends State<OtpBody> {
  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  String? verificationCode;
  String pin = " ";

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: GoogleFonts.poppins(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(),
  );

  final cursor = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 56,
        height: 3,
        decoration: BoxDecoration(
          color: Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );

  final preFilledWidget = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 56,
        height: 3,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 140, 204, 255),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();

    verifyPhoneNumber();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.codeDigits + widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async{
        await FirebaseAuth.instance.signInWithCredential(credential).then((value){
          if(value.user != null){
            Navigator.of(context).push(MaterialPageRoute(builder: (c) => OtpVerified()));
          }
        });
      },
      verificationFailed: (FirebaseAuthException e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vID, int? resendToken){
        setState(() {
          verificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID){
        setState(() {
          verificationCode = vID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  Future<void> verifyOTP() async {
    await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationCode!,
        smsCode: pin,
      ),
    ).whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OtpVerified(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    //total height and width
    return Scaffold(
      key: _scaffolkey,
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: SingleChildScrollView(
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
            Container(
              margin: const EdgeInsets.fromLTRB(30, 60, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Image.asset("assets/images/mini logo.png",
                    width: size.width * 0.2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "Verify Phone Number",
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.171875,
                        fontSize: 26.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 32, 32, 32),
                        letterSpacing: -1.6800000000000002,
                      ),
                    ),
                  ),
                  Text(
                    "Please enter the 6 digit code sent to",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.171875,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 126, 126, 126),
                      letterSpacing: -0.48,
                    ),
                  ),
                  Text(
                    "${widget.codeDigits}${widget.phone}",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.171875,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 53, 53, 53),
                      letterSpacing: -0.48,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Pinput(
                        length: 6,
                        pinAnimationType: PinAnimationType.slide,
                        controller: _pinOTPCodeController,
                        focusNode: _pinOTPCodeFocus,
                        defaultPinTheme: defaultPinTheme,
                        showCursor: true,
                        cursor: cursor,
                        preFilledWidget: preFilledWidget,
                        onChanged: (value) {
                          setState(() {
                            pin = value;
                          });
                        },
                        onSubmitted: (pin) async {
                          try{
                            await FirebaseAuth.instance
                                .signInWithCredential(PhoneAuthProvider
                                .credential(verificationId: verificationCode!, smsCode: pin))
                                .then((value) {
                              if(value.user != null){
                                Navigator.of(context).push(MaterialPageRoute(builder: (c) => OtpVerified()));
                              }
                            });
                          }
                          catch(e){
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Invalid OTP!"),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                    ),
                  ),
                  const SizedBox(height: 20,),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't receive the code? ",
                          style: TextStyle(
                            height: 1.171875,
                            fontSize: 16.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 126, 126, 126),
                            letterSpacing: -0.56,
                          ),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              verifyPhoneNumber();
                            },
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                height: 1.171875,
                                fontSize: 16.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 123, 20, 255),
                                letterSpacing: -0.56,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50, top: 15),
                    child: GestureDetector(
                      child: Text("Change Mobile Number",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          height: 1.171875,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 39, 39, 39),
                          decoration: TextDecoration.underline,
                          letterSpacing: -0.48,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignUp()));
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      onPressed: (){
                        if(pin.length >= 6) {
                          verifyOTP();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Invalid OTP!"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      minWidth: double.infinity,
                      child: Text("Verify number",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}