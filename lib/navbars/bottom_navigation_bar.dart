import 'package:dishio/screens/profile/profile.dart';
import 'package:dishio/screens/recipe_adding/recipe_adding.dart';
import 'package:dishio/screens/searching/dish_finder.dart';
import 'package:dishio/screens/searching/searching.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(),
          ),
        );
      } else if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DishFinderScreen(),
          ),
        );
      } else if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileView(),
          ),
        );
      } else if (_selectedIndex == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeAdd(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(Icons.dining_sharp), label: 'Finder'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New recipe'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: MyColors.color5,
      unselectedItemColor: MyColors.color4,
      onTap: _onTapped,
    );
  }
}
