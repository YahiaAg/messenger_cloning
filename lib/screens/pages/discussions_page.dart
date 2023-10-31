import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/chat_screen.dart';
import '../../providers/user.dart';
import '../../providers/users.dart';
import '../../widgets/user_badge.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({super.key});

  @override
  State<DiscussionPage> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionPage> {
  User currentUser = User(name: "", uid: "");
  @override
  void initState() {
    Provider.of<User>(context, listen: false).currentUser.then((value) async {
      currentUser = value;
    });
    Provider.of<Users>(context, listen: false).fetchAndSetUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final users = Provider.of<Users>(context).users;

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
              itemCount: users.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                final firstName = users[index].name.split(" ")[0];
                final lastName =
                    users[index].name.split(" ").length == 1
                        ? ""
                        : users[index].name.split(" ")[1];
                return Padding(
                  padding: EdgeInsets.only(
                    left: deviceSize.width * 0.04,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Consumer<User>(
                          builder: (context, value, child) =>UserBadge(
                            imageUrl: users[index].profilePicture,
                            isOnline: users[index].isOnline,
                          ), 
                        
                        ),
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
            height: deviceSize.height * 0.7,
            width: deviceSize.width,
            child: ListView.builder(
              itemBuilder: (ctx, index) => InkWell(
                onTap: () => Navigator.of(context).pushNamed(
                  ChatScreen.routeName,
                  arguments: users[index].uid,),
                child: ListTile(
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: UserBadge(
                      imageUrl: users[index].profilePicture,
                      isOnline: users[index].isOnline,
                    ),
                  ),
                  title: Text(users[index].name),
                  subtitle: const Text("lastMessage"),
                  trailing: const Text("lastMessageTime"),
                ),
              ),
              itemCount: users.length,
            ),
          )
        ],
      ),
    );
  }
}
