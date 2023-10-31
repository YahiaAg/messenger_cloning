import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/main_screen.dart';
import '../providers/user.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _password = "";
  String _email = "";
  String _username = "";
  XFile? _userImage;
  void _pickImage() async {
    _userImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  void login(BuildContext context) async {
    final userProvider = Provider.of<User>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        userProvider.signUp(_email, _password, _username, _userImage);
        Navigator.of(context).pushReplacementNamed(MainScreen.routeName);

      } on PlatformException catch (e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("ivalid credentials"),
                content: Text(e.message ?? "something went wrong"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Ok"))
                ],
              );
            });
      } catch (e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("try again"),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Ok"))
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.length < 5 ||
                        value.length > 20) {
                      return "Please enter a valid username";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Username",
                  ),
                  onSaved: (newValue) => _username = newValue!,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return "Please enter a valid email address";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "   Email",
                      hintText: "Enter your email",
                      border: InputBorder.none),
                  onSaved: (newValue) => _email = newValue!.trim(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return "Please enter a valid password";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      border: InputBorder.none),
                  obscureText: true,
                  onSaved: (newValue) => _password = newValue!,
                ),
              ),
              FilledButton(
                  onPressed: () {
                    login(context);
                  },
                  child: const Text("Sign Up")),
              TextButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child:
                      const Text("You can add your profile picture from here"))
            ],
          ),
        ),
      ),
    );
  }
}
