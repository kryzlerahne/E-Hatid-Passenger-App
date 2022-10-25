import 'package:ehatid_passenger_app/app_info.dart';
import 'package:ehatid_passenger_app/history_design_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TripsHistoryScreen extends StatefulWidget
{
  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}


class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Color(0xFFEBE5D8),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text(
            "Trips History",
            style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
          separatorBuilder: (context, i)=> Divider(
            color: Colors.grey,
            thickness: 2,
            height: 0.5.h,
          ),
          itemBuilder: (context, i)
          {
            return Card(
              color: Colors.white54,
              child: HistoryDesignUIWidget(
                tripsHistoryModel: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList[i],
              ),
            );
          },
          itemCount: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
      ),
    );
  }
}
