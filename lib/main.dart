import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

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
        routes: {MainScreen.routeName: (ctx) => const MainScreen()},
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
