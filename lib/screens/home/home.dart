import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishio/navbars/hamburgermenu.dart';
import 'package:dishio/services/auth.dart';
import 'package:dishio/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:dishio/style/colors.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService auth = AuthService();
  ScrollController _scrollController = ScrollController();
  List<String> _buttonNames = List.generate(11, (index) => "Index $index");

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HamburgerMenu(),
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
          "Dishio",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.black),
                      bottom: BorderSide(width: 1.0, color: Colors.black),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: StreamBuilder(
                        stream: DatabaseService(uid: '')
                            .categoryCollection
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot2) {
                          if (!snapshot2.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Row(
                            children: snapshot2.data!.docs.map((document) {
                              String button = document['name'];
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    print('Kliknięto przycisk: $button');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    elevation: 0,
                                    side: BorderSide.none,
                                  ),
                                  child: Text(
                                    button,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          10, // Zmniejszenie rozmiaru czcionki na 10
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
