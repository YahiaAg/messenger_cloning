import 'package:flutter/material.dart';

import './pages/discussions_page.dart';
import './pages/contacts_page.dart';
import '../widgets/bottom_navigaton_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const routeName = 'main_screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _pages = [const DiscussionPage(), const ContactsPage()];
  var index = 0;
  void _onTap(int myIndex) {
    setState(() {
      index = myIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavBar(index: index, onTap: _onTap),
      appBar: AppBar(
        title: index == 0
            ? const Text("Discussions")
            : index == 1
                ? const Text("contacts")
                : index == 2
                    ? const Text("Stories")
                    : const Text("Settings"),
        leading: const Icon(Icons.menu_rounded),
      ),
      body: _pages[index],
    );
  }
}
