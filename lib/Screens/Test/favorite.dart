import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Favorite'),
      ),
    );
  }
}