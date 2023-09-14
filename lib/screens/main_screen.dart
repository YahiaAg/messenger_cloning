import 'package:flutter/material.dart';

import './pages/discussions_page.dart';
import '../widgets/bottom_navigaton_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const routeName = 'main_screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _onTap(int index) {
    setState(() {
      index = index;
    });
  }

  final List<Widget> _pages = [const DiscussionPage()];
  final index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavBar(index: index, onTap: _onTap),
      appBar: AppBar(
        title: const Text("messenger"),
      ),
      body: _pages[index],
    );
  }
}
