import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyBottomNavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  const MyBottomNavBar({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      useLegacyColorScheme: false,
        iconSize: 28,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: index,
        showUnselectedLabels: true,
        onTap: (index) {
          onTap(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.chat_bubble_fill,
            ),
            label: "discussions",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2_fill),
            label: "contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_stack_3d_down_right_fill),
            label: "stories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "settings",
          ),
        ]);
  }
}
