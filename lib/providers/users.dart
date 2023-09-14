import 'package:flutter/material.dart';
import './user.dart';

class Users with ChangeNotifier {
  final List<User> _users = [
    User(uid: "yahia", name: "yahia aguida"),
    User(uid: "ahmed", name: "ahmed aguida"),
    User(uid: "mohamed", name: "mohamed aguida"),
    User(uid: "ali", name: "ali aguida"),
    User(uid: "khaled", name: "khaled aguida"),
    User(uid: "nader", name: "nader aguida"),
    User(uid: "yassine", name: "yassine aguida"),
    User(uid: "max", name: "max aguida"),
    User(uid: "mohamedali", name: "mohamedali aguida"),
  ];
  List<User> get users => [..._users];
  
}
