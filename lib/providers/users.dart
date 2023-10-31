import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './user.dart';

class Users with ChangeNotifier {
  List<User> _users = [];
  final db = FirebaseFirestore.instance;
  void fetchAndSetUsers() async {
    final List<User> users = [];
    final usersDocuments = await db.collection('users').get();
    usersDocuments.docs.forEach((element) {
      print(element.data());
      print("hello world ");
      users.add(User(
        isOnline: element.data()['isOnline'],
        name: element.data()['username'],
        uid: element.data()['uid'],
        profilePicture: element.data()['imageUrl'] == ""
            ? null
            : element.data()['imageUrl'],
      ));
    });
    _users = [...users];
    notifyListeners();
  }

  List<User> get users => [..._users];
}
