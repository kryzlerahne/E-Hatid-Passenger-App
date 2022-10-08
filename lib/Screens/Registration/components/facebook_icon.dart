import 'package:flutter/material.dart';

class FacebookIcon extends StatelessWidget {
  final String iconSrc;
  final VoidCallback press;
  const FacebookIcon({
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
          color: Color.fromARGB(255, 78, 98, 151),
        ),
        child: Image.asset(iconSrc),
      ),
    );
  }
}