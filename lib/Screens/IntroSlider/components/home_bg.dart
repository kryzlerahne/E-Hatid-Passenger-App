import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  final Widget child;
  const HomeBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      color: Color(0xFFF8D516),// <--- add here
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Image.asset(
              "assets/images/Vector 1.png",
              width: size.width,
            ),
          ),
          child,
        ],
      ),
    );
  }
}