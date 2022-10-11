import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


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
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [

               SizedBox(width: Adaptive.w(2),),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),

               SizedBox(width: Adaptive.w(8),),

              Text(
                message!,
                style: TextStyle( color: Color(0xbc000000),
                  fontSize: 15,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
