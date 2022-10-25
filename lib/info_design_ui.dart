import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InfoDesignUIWidget extends StatefulWidget
{
  String? textInfo;
  IconData? iconData;

  InfoDesignUIWidget({this.textInfo, this.iconData});

  @override
  State<InfoDesignUIWidget> createState() => _InfoDesignUIWidgetState();
}




class _InfoDesignUIWidgetState extends State<InfoDesignUIWidget>
{
  @override
  Widget build(BuildContext context)
  {
    return Card(
      color: Colors.white54,
      margin: EdgeInsets.symmetric(vertical: 3.w, horizontal: 5.h),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.grey,
        ),
        title: Text(
          widget.textInfo!,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontSize: 19.sp,
              letterSpacing: -1,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
