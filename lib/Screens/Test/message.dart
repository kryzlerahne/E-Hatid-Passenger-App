import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Message'),
      ),
    );
  }
}