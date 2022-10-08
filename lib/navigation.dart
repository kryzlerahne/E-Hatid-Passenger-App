import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ehatid_passenger_app/Screens/Home/homescreen.dart';
import 'package:ehatid_passenger_app/Screens/Login/components/register.dart';
import 'package:ehatid_passenger_app/Screens/Login/sign_in.dart';
import 'package:ehatid_passenger_app/Screens/Registration/sign_up.dart';
import 'package:ehatid_passenger_app/Screens/Test/Identity.dart';
import 'package:ehatid_passenger_app/Screens/Test/favorite.dart';
import 'package:ehatid_passenger_app/Screens/Test/message.dart';
import 'package:ehatid_passenger_app/Screens/Wallet/wallet.dart';
import 'package:ehatid_passenger_app/map_page.dart';
import 'package:ehatid_passenger_app/navigation_screen.dart';
import 'package:ehatid_passenger_app/order_traking_page.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  var myindex = 0;

  var PagesAll = [MapSample(),Wallet(),MessagePage(),FavoritePage()];

  @override
  Widget build(BuildContext context) {
    //total height and width
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFCEA),
        bottomNavigationBar: CurvedNavigationBar(
          key: _navKey,
          items: [
            Icon((myindex == 0) ? Icons.home_outlined : Icons.home, size: 30,),
            Icon((myindex == 1) ? Icons.account_balance_wallet_outlined : Icons.account_balance_wallet, size: 30,),
            Icon((myindex == 2) ? Icons.history_outlined : Icons.history, size: 30,),
            Icon((myindex == 3) ? Icons.circle_notifications_outlined : Icons.circle_notifications , size: 30,),
          ],
          height: 60,
          backgroundColor: Color(0xFFFED90F),
          color: Color(0xFFF3E8AE),
          animationDuration: Duration(milliseconds: 300),
          onTap: (index){
            setState(() {
              myindex = index;
            });
          },
          animationCurve: Curves.fastLinearToSlowEaseIn,
        ),
        body: PagesAll[myindex],
      ),
    );
  }
}