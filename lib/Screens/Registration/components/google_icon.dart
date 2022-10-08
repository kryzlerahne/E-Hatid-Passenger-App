import 'package:flutter/material.dart';

class GoogleIcon extends StatelessWidget {
  final String iconSrc;
  final VoidCallback press;
  const GoogleIcon({
    Key? key,
    required this.iconSrc,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 197, 51, 30),
        ),
        child: Image.asset(iconSrc),
      ),
    );
  }
}