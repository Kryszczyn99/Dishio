import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishio/screens/profile/editing.dart';
import 'package:dishio/style/profileButtonDecoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import '../../style/colors.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => new ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: NavBar(),
        backgroundColor: MyColors.color10,
        appBar: AppBar(
          bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0),
          ),
          backgroundColor: MyColors.color6,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
          ),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: DatabaseService(uid: '')
                  .userCollection
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var user = snapshot.data!.docs[0];
                  var names;
                  var role;
                  if (user.get('name').toString().isEmpty &&
                      user.get('surname').toString().isEmpty) {
                    names = "[Brak danych]";
                  } else {
                    names = user.get('name') + " " + user.get('surname');
                  }
                  if (user.get('role') == "user") {
                    role = "User";
                  } else {
                    role = "Admin";
                  }
                  return Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                            1 /
                                            10),
                                decoration: BoxDecoration(
                                  color: MyColors.color6,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                      color: Colors.black, width: 0.75),
                                ),
                                width:
                                    MediaQuery.of(context).size.width * 4 / 5,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 135,
                                      width: 135,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 0.75,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/person.png'),
                                          fit: BoxFit.fill,
                                        ),
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('${role}',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('${names}',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('${user.get('email')}',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white)),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.white,
                                height: 75,
                                thickness: 1,
                                indent: 45,
                                endIndent: 45,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: raisedButtonStyle,
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         TicketsHistory(),
                                      //   ),
                                      // );
                                    },
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text('XYZ',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: raisedButtonStyle,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditData(),
                                        ),
                                      );
                                    },
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text('Edit data',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: raisedButtonStyle,
                                    onPressed: () async {},
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text('Change avatar',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: raisedDangerButtonStyle,
                                      onPressed: () async {
                                        Widget cancelButton = TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                        Widget continueButton = TextButton(
                                          child: Text("Continue"),
                                          onPressed: () async {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                            await AuthService().deleteUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                                    .toString());
                                          },
                                        );

                                        // set up the AlertDialog
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Alert"),
                                          content: Text(
                                              "Do you want to delete your account?"),
                                          actions: [
                                            cancelButton,
                                            continueButton,
                                          ],
                                        );

                                        // show the dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      },
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text('Delete account',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                            ],
                          )),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ));
  }
}
