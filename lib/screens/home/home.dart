import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishio/navbars/hamburgermenu.dart';
import 'package:dishio/screens/details/recipe_details.dart';
import 'package:dishio/screens/recipe_adding/recipe_adding.dart';
import 'package:dishio/services/auth.dart';
import 'package:dishio/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:dishio/style/colors.dart';
import 'package:intl/intl.dart';

import '../../services/firebasestorageapi.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService auth = AuthService();
  ScrollController _scrollController = ScrollController();
  List<String> _buttonNames = List.generate(11, (index) => "Index $index");
  String _currentCategories = "Wszystkie";

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
        backgroundColor: MyColors.color6,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Dishio",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeAdd(),
                ),
              );
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Visibility(
                      visible: _currentCategories != "Wszystkie",
                      child: StreamBuilder(
                          stream: DatabaseService(uid: '')
                              .recipeCollection
                              .where('category', isEqualTo: _currentCategories)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot2) {
                            if (!snapshot2.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            print(_currentCategories);
                            return Container(
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: snapshot2.data!.docs.map((document) {
                                  String title = document['title'];
                                  String time = document['time'];
                                  return Column(children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: FutureBuilder(
                                                future: _getImage(
                                                    context, document.id),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<Widget>
                                                        snapshot) {
                                                  return Container(
                                                    child: snapshot.data,
                                                  );
                                                }),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await DatabaseService(uid: '')
                                                    .incrementView(document.id);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeDetails(
                                                            id: document.id),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                constraints:
                                                    BoxConstraints.expand(),
                                                color: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        title,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "~" + time + "min",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]);
                                }).toList(),
                              ),
                            );
                          }),
                    ),
                    Visibility(
                      visible: _currentCategories == "Wszystkie",
                      child: StreamBuilder(
                          stream: DatabaseService(uid: '')
                              .recipeCollection
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot2) {
                            if (!snapshot2.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            print(_currentCategories);
                            return Container(
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: snapshot2.data!.docs.map((document) {
                                  String title = document['title'];
                                  String time = document['time'];
                                  return Column(children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: FutureBuilder(
                                                future: _getImage(
                                                    context, document.id),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<Widget>
                                                        snapshot) {
                                                  return Container(
                                                    child: snapshot.data,
                                                  );
                                                }),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await DatabaseService(uid: '')
                                                    .incrementView(document.id);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeDetails(
                                                            id: document.id),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                constraints:
                                                    BoxConstraints.expand(),
                                                color: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        title,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "~" + time + "min",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]);
                                }).toList(),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
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
                    stream:
                        DatabaseService(uid: '').categoryCollection.snapshots(),
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
                                setState(() {
                                  _currentCategories = button;
                                });
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
          ),
        ],
      ),
    );
  }

  Future<Widget> _getImage(BuildContext context, String id) async {
    late Widget image;
    List<Widget> images = [];
    try {
      var storageRef = FirebaseStorage.instance.ref("images/$id");
      ListResult temp = await storageRef.listAll();
      for (var item in temp.items) {
        String path = item.fullPath.toString();
        await FirebaseApi.loadImage(context, path).then((value) {
          image = Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(value.toString()),
                fit: BoxFit.cover,
              ),
            ),
          );
          images.add(image);
        });
      }
      image = Container(
          width: double.infinity,
          height: 200,
          child: PageView(
            children: images,
          ));
    } catch (err) {
      return Scaffold();
    }
    return image;
  }
}
