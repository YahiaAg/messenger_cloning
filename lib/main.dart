import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import 'screens/chat_screen.dart';
import './providers/user.dart';
import './screens/main_screen.dart';
import './providers/users.dart';
import './screens/auth_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    const Color blueColor = Color.fromRGBO(55, 122, 246, 1);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Users()),
        ChangeNotifierProvider(create: (ctx) => User(name: '', uid: '')),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        title: 'Messenger',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ), // This is the theme of your application.
          useMaterial3: true,

          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: blueColor,
              background: Colors.white,
              secondary: Colors.grey,
              surface: Colors.white),
        ),
        home: const MyHomePage(),
        routes: {MainScreen.routeName: (ctx) => const MainScreen(),
        ChatScreen.routeName: (ctx) => const ChatScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String uid = "";
  @override
  void initState()  {
    WidgetsBinding.instance.addObserver(this);
     Provider.of<User>(context, listen: false).currentUser.then((value) => uid=value.uid);
     
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state: $state");
    if (state == AppLifecycleState.resumed) {
      Provider.of<User>(context, listen: false).makeUserOnline();
    } else {
      if (state == AppLifecycleState.paused 
      || state==AppLifecycleState.inactive
      || state==AppLifecycleState.hidden) {
         firestore.FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "isOnline": false,
    });
      }
    }
  }

  @override
  void dispose() {
    Provider.of<User>(context, listen: false).makeUserOffline();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<User>(context, listen: false).currentUser,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.data!.isLogin) {
            return const MainScreen();
          } else {
            return const AuthScreen();
          }
        });
  }
}
