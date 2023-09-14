import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
// ignore: library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

import '../local_database/database.dart';

class User with ChangeNotifier {
  final String uid;
  final String name;
  final Image? profilePicture;
  final bool isLogin;
  User(
      {required this.uid,
      required this.name,
      this.profilePicture,
      this.isLogin = false});
  Future<User> get currentUser async {
    final usersTable = await MyDatabase.getData("user");
    if (usersTable.isEmpty) {
      return User(uid: "", name: "", isLogin: false);
    } else {
      var connectivityResult = Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        await FirebaseAuth.FirebaseAuth.instance.signInWithEmailAndPassword(
            email: usersTable[0]["email"], password: usersTable[0]["password"]);
      }
      return User(
        uid: usersTable[0]["uid"],
        name: usersTable[0]["username"],
        isLogin: true,
      );
    }
  }

  Future<void> signUp(
      String email, String password, String name, XFile? userImage) async {
    FirebaseAuth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(value.user!.uid)
          .set({
        "uid": value.user!.uid,
        "email": value.user!.email!,
        "username": name,
        "password": password,
      });

      await MyDatabase.insert("user", {
        "uid": value.user!.uid,
        "email": value.user!.email!,
        "username": name,
        "password": password,
        "image": userImage!.readAsBytes(),
      });
      notifyListeners();
    });
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    await FirebaseAuth.FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(value.user!.uid)
          .set({
        "uid": value.user!.uid,
        "email": value.user!.email!,
        "username": name,
        "password": password,
      });
      await MyDatabase.insert("user", {
        "uid": value.user!.uid,
        "email": value.user!.email!,
        "username": name,
        "password": password,
      });
      notifyListeners();
    });
  }

  void removeUser(User user) {
    notifyListeners();
  }

  void updateUser(User user) {
    notifyListeners();
  }

  User? getUser(String uid) {
    return null;
  }
}
