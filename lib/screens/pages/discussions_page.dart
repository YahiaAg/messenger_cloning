import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

import '../../providers/user.dart';
import '../../providers/users.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({super.key});

  @override
  State<DiscussionPage> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionPage> {
  User currentUser = User(uid: '', name: '');
  var myContacts = {};
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<User>(context as BuildContext, listen: false).currentUser.then((value) async {
      currentUser = value;
      final firebaseUser =
          FirebaseDatabase.instance.ref().child("users").child(currentUser.uid);
      currentUser = User(
        name: firebaseUser.child("username").toString(),
        uid: firebaseUser.child("uid").toString(),
        profilePicture: Image.network(
          firebaseUser.child("imageUrl").toString(),
        ),
      );
      myContacts = await firebaseUser.child("contacts").get() as Map;

      print(myContacts);
      print(firebaseUser.child("contacts").get());
    });
      
    });
    
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final myContacts = Provider.of<Users>(context).users;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: deviceSize.height * 0.02,
              left: deviceSize.width * 0.03,
              right: deviceSize.width * 0.03,
            ),
            child: SearchAnchor.bar(
                //this is a search bar
                barElevation: const MaterialStatePropertyAll(0.0),
                barBackgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                constraints: BoxConstraints(
                  maxHeight: deviceSize.height * 0.05,
                  minHeight: deviceSize.height * 0.05,
                  maxWidth: deviceSize.width * 0.90,
                ),
                suggestionsBuilder: (ctx, controller) => [
                      const Text("yahia"),
                      const Text("ahmed"),
                      const Text("ali"),
                      const Text("mohamed"),
                      const Text("khaled"),
                      const Text("nader"),
                    ]),
          ),
          Container(
            //this is a list of contacts
            alignment: Alignment.center,
            height: deviceSize.height * 0.15,
            width: deviceSize.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                final firstName = myContacts[index].name.split(" ")[0];
                final lastName = myContacts[index].name.split(" ")[1];
                return Padding(
                  padding: EdgeInsets.only(
                    left: deviceSize.width * 0.04,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        minRadius: deviceSize.height * 0.03,
                        backgroundColor: Colors.grey,
                        foregroundImage:
                            myContacts[index].profilePicture?.image,
                      ),
                      Text(
                        firstName,
                      ),
                      Text(
                        lastName,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            //this is a list of discussions
            height: deviceSize.height * 0.75,
            width: deviceSize.width,
            child: ListView.builder(
              itemBuilder: (ctx, index) => Material(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    foregroundImage: myContacts[index].profilePicture?.image,
                  ),
                  title: Text(myContacts[index].name),
                  subtitle: const Text("lastMessage"),
                  trailing: const Text("lastMessageTime"),
                ),
              ),
              itemCount: myContacts.length,
            ),
          )
        ],
      ),
    );
  }
}
