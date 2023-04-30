import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishio/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../services/database.dart';

class UsersTableScreen extends StatefulWidget {
  const UsersTableScreen({super.key});

  @override
  State<UsersTableScreen> createState() => _UsersTableScreenState();
}

class _UsersTableScreenState extends State<UsersTableScreen> {
  String text = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Users Table",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: TextStyle(color: MyColors.color6, fontSize: 20),
                  textAlign: TextAlign.center,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Find user by email',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: MyColors.color8,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => text = val);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  color: MyColors.color5,
                  thickness: 1,
                ),
                StreamBuilder(
                    stream: DatabaseService(uid: '')
                        .userCollection
                        .where('email', isGreaterThanOrEqualTo: text)
                        .where('email', isLessThan: text + 'z')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot2) {
                      if (!snapshot2.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Container(
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 20),
                          children: snapshot2.data!.docs.map((document) {
                            return Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        4 /
                                        5,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 30),
                                    decoration: BoxDecoration(
                                        color: MyColors.color8.withOpacity(0.8),
                                        border: Border.all(
                                            width: 3,
                                            color: MyColors.color7
                                                .withOpacity(0.8)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${document['email']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: document['role'] == 'admin',
                                          child: Text(
                                            "Role: ${document['role']}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Visibility(
                                          visible: document['role'] != 'admin',
                                          child: Text(
                                            "Role: ${document['role']}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            document['role'] == 'admin'
                                                ? TextButton.icon(
                                                    onPressed: () async {
                                                      await DatabaseService(
                                                              uid: '')
                                                          .becomeUser(
                                                              document.id);
                                                    },
                                                    icon: Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    ),
                                                    label: Text(
                                                      "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  )
                                                : TextButton.icon(
                                                    onPressed: () async {
                                                      await DatabaseService(
                                                              uid: '')
                                                          .becomeAdmin(
                                                              document.id);
                                                    },
                                                    icon: Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                    ),
                                                    label: Text(
                                                      "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                            TextButton.icon(
                                              onPressed: () async {
                                                // await DatabaseService(uid: '')
                                                //     .banUser(document.id);
                                              },
                                              icon: Icon(
                                                Icons.block,
                                                color: Colors.red,
                                              ),
                                              label: Text(
                                                "Ban",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
