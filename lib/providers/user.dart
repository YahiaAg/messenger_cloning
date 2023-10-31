// ignore: library_prefixes

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:image_picker/image_picker.dart';

import '../local_database/database.dart';

class User with ChangeNotifier {
  final String uid;
  final String name;
  final String? profilePicture;
  final bool isLogin;
  final bool isOnline;
  User(
      {required this.uid,
      required this.name,
      this.profilePicture,
      this.isLogin = false,
      this.isOnline = false});
  Future<User> get currentUser async {
    final usersTable = await MyDatabase.getData("user");
    if (usersTable.isEmpty) {
      return User(uid: "", name: "", isLogin: false);
    } else {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
            email: usersTable[0]["email"], password: usersTable[0]["password"]);
      }
      await firestore.FirebaseFirestore.instance
          .collection("users")
          .doc(usersTable[0]["uid"])
          .set({
        "uid": usersTable[0]["uid"],
        "email": usersTable[0]["email"],
        "username": usersTable[0]["username"],
        "password": usersTable[0]["password"],
        "isOnline": true,
        "islLogin": true,
      });
      return User(
          uid: usersTable[0]["uid"],
          name: usersTable[0]["username"],
          isLogin: true,
          isOnline: true);
    }
  }

  Future<void> signUp(
      String email, String password, String name, XFile? userImage) async {
    final db = firestore.FirebaseFirestore.instance;
    firebase_auth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await db.collection("users").doc(value.user!.uid).set({
        "uid": value.user!.uid,
        "email": value.user!.email!,
        "username": name,
        "password": password,
      });
      MyDatabase.insert("user", {
        "uid": value.user!.uid,
        "email": value.user!.email!,
        "username": name,
        "password": password,
      });
      notifyListeners();
    });
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    final db = firestore.FirebaseFirestore.instance;
    await firebase_auth.FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      db.collection("users").doc(value.user!.uid).set({
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
  void makeUserOnline() async{
    final user = await currentUser;
    print("makeUserOffline $uid");
    await firestore.FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({
      "isOnline": true,
    });
    notifyListeners();
  }

  void makeUserOffline() async {
    final user = await currentUser;
    print("makeUserOffline $uid");
    await firestore.FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({
      "isOnline": false,
    });
    notifyListeners();
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
