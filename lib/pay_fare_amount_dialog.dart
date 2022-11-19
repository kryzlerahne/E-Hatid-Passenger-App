import 'package:ehatid_passenger_app/trips_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class PayFareAmountDialog extends StatefulWidget
{
  double? fareAmount;
  TripsHistoryModel? tripsHistoryModel;

  PayFareAmountDialog({this.fareAmount, this.tripsHistoryModel});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}


class _PayFareAmountDialogState extends State<PayFareAmountDialog>
{
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

          Stack(
          alignment: Alignment.center,
          children: [

            Container(
              height: 9.h,
              decoration: BoxDecoration(
                color: Color(0XFF0CBB8A),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),

            Text(
              "Trip Fare Amount",
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

            SizedBox(height: 5.h),

            Text(
              "₱" + widget.fareAmount!.toStringAsFixed(2),
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                color: Color(0xFF0CBC8B),
                fontSize: 50,
              ),
            ),

            SizedBox(height: 1.h),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "This is the total trip fare amount, Please pay it to the driver.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 50.w,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child:
                MaterialButton(
                  onPressed: (){
                    Future.delayed(const Duration(milliseconds: 2000), ()
                    {
                      Navigator.pop(context, "cashPayed");
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Pay Cash", style: TextStyle( color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,),),
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ],
                  ),
                  color: Color(0XFF0CBC8B),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}

