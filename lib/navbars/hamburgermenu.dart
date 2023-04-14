import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishio/screens/home/home.dart';
import 'package:dishio/screens/profile/profile.dart';
import 'package:dishio/services/auth.dart';
import 'package:dishio/services/database.dart';
import 'package:dishio/storage/firebasestorageapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../style/colors.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    return StreamBuilder(
        stream: DatabaseService(uid: '')
            .userCollection
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data!.docs[0];
            var names;
            if (user.get('name').toString().isEmpty &&
                user.get('surname').toString().isEmpty) {
              names = "[Brak danych]";
            } else {
              names = user.get('name') + " " + user.get('surname');
            }
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text("${names}"),
                    accountEmail: Text("${user.get('email')}"),
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/person.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.color6,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.dining_sharp),
                    title: Text("Main"),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Profile"),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileView(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Log out"),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      await auth.signOut();
                    },
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
