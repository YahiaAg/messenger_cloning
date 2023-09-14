import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../screens/main_screen.dart';
import '../providers/user.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _password = "";
  String _email = "";
  void login(BuildContext context) async {
    final userProvider = Provider.of<User>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        userProvider.signIn(_email, _password);
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
      Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
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
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
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
                  child: const Text("Sign In")),
          ],
        ),
      ),
    );
  }
}
