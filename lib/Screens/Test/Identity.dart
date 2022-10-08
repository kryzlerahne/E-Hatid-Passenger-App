import 'package:flutter/material.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({Key? key}) : super(key: key);

  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State  {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Identity'),
      ),
    );
  }
}