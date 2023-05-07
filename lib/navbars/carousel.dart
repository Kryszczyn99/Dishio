import 'package:carousel_slider/carousel_slider.dart';
import 'package:dishio/screens/admin_screens/category_add.dart';
import 'package:dishio/screens/admin_screens/reports.dart';
import 'package:dishio/screens/admin_screens/users.dart';

import 'package:dishio/screens/home/home.dart';
import 'package:dishio/screens/profile/profile.dart';
import 'package:dishio/screens/searching/dish_finder.dart';
import 'package:dishio/screens/searching/searching.dart';
import 'package:dishio/services/auth.dart';
import 'package:flutter/material.dart';

class MyCarousel extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final List _carouselItems = [
      {
        "color": Colors.green,
        "text": "Home",
        "onPressed": new Home(),
        "icon": Icons.dining_sharp,
      },
      {
        "color": Colors.green,
        "text": "Profile",
        "onPressed": new ProfileView(),
        "icon": Icons.person,
      },
      {
        "color": Colors.green,
        "text": "Search",
        "onPressed": new SearchScreen(),
        "icon": Icons.search,
      },
      {
        "color": Colors.green,
        "text": "Dish finder",
        "onPressed": new DishFinderScreen(),
        "icon": Icons.find_in_page,
      },
      {
        "color": Colors.green,
        "text": "Users (Admin)",
        "onPressed": new UsersTableScreen(),
        "icon": Icons.people,
      },
      {
        "color": Colors.green,
        "text": "Category (Admin)",
        "onPressed": new CategoryAddScreen(),
        "icon": Icons.category,
      },
      {
        "color": Colors.green,
        "text": "Reports (Admin)",
        "onPressed": new ReportScreen(),
        "icon": Icons.report,
      },
      {
        "color": Colors.red,
        "text": "Log out",
        "onPressed": () {},
        "icon": Icons.logout,
      },
    ];
    return CarouselSlider(
      options: CarouselOptions(
          height: 200.0,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          autoPlayCurve: Curves.fastOutSlowIn,
          aspectRatio: 16 / 9),
      items: _carouselItems.map((item) {
        return Builder(
          builder: (BuildContext context) {
            if (item['text'] == 'Log out') {
              return GestureDetector(
                onTap: () async {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  await auth.signOut();
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: item['color'],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        )),
                    child: Center(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  '${item['text']}  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 32.0, color: Colors.white),
                                ),
                                Icon(
                                  item['icon'],
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ],
                            )))),
              );
            }
            return GestureDetector(
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => item['onPressed']))
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      )),
                  child: Center(
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                '${item['text']}  ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 32.0, color: Colors.white),
                              ),
                              Icon(
                                item['icon'],
                                color: Colors.white,
                                size: 32,
                              ),
                            ],
                          )))),
            );
          },
        );
      }).toList(),
    );
  }
}
