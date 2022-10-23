import 'package:firebase_database/firebase_database.dart';

class UserModel
{
  String? first_name;
  String? last_name;
  String? id;
  String? email;
  String? username;

  UserModel({this.first_name, this.last_name, this.id, this.email, this.username,});

  UserModel.fromSnapshot(DataSnapshot snap)
  {
    first_name = (snap.value as dynamic)["first_name"];
    last_name = (snap.value as dynamic)["last_name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
    username = (snap.value as dynamic)["username"];
  }
}