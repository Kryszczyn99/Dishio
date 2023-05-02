import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishio/screens/details/recipe_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../navbars/hamburgermenu.dart';
import '../../services/database.dart';
import '../../services/firebasestorageapi.dart';
import '../../style/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = "";
  String? _selectedCategory = "Wszystkie";

  RangeValues viewsRangeValues = RangeValues(0, 100000);
  RangeValues likesRangeValues = RangeValues(0, 10000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HamburgerMenu(),
      backgroundColor: MyColors.color8,
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        backgroundColor: MyColors.color6,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Searching",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (text) {
                      setState(() {
                        searchText = text;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Category",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder(
                    stream:
                        DatabaseService(uid: '').categoryCollection.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<String> catArray = [];
                      for (var cat in snapshot.data!.docs) {
                        catArray.add(cat.get('name'));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            width: 400,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: DropdownButton<String>(
                              icon: Icon(Icons.restaurant_menu),
                              value: _selectedCategory,
                              items: catArray
                                  .map(
                                    (category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              menuMaxHeight: 500,
                              underline: Container(),
                              isExpanded: true,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Views",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Range slider for views
                  RangeSlider(
                    values: viewsRangeValues,
                    min: 0,
                    max: 100000,
                    divisions: 100,
                    labels: RangeLabels(
                      viewsRangeValues.start.round().toString(),
                      viewsRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        viewsRangeValues = values;
                      });
                    },
                  ),

                  const SizedBox(height: 24),
                  Text(
                    "Likes",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Range slider for likes
                  RangeSlider(
                    values: likesRangeValues,
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    labels: RangeLabels(
                      likesRangeValues.start.round().toString(),
                      likesRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        likesRangeValues = values;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 75,
              thickness: 1,
              indent: 25,
              endIndent: 25,
            ),
            StreamBuilder(
                stream: DatabaseService(uid: '')
                    .recipeCollection
                    .where("views",
                        isGreaterThanOrEqualTo: viewsRangeValues.start)
                    .where("views", isLessThanOrEqualTo: viewsRangeValues.end)
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
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: snapshot2.data!.docs.map((document) {
                        String title = document['title'];
                        String time = document['time'];
                        String category = document['category'];
                        print(category);
                        if (searchText != "") {
                          bool res = title
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                          if (res == false) return Container();
                        }
                        if (_selectedCategory == "Wszystkie") {
                        } else if (_selectedCategory != "Wszystkie" &&
                            category != _selectedCategory) {
                          return Container();
                        }
                        return Column(children: [
                          FutureBuilder(
                            future: DatabaseService(uid: '')
                                .countLikes(document.id),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot3) {
                              if (!snapshot3.hasData) {
                                return CircularProgressIndicator();
                              }
                              int? like = snapshot3.data;
                              if (like!.toInt() >=
                                      likesRangeValues.start.toInt() &&
                                  like.toInt() <=
                                      likesRangeValues.end.toInt()) {
                                return Column(
                                  children: [
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
                                                bool res =
                                                    await DatabaseService(
                                                            uid: '')
                                                        .checkIfAdmin(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeDetails(
                                                            id: document.id,
                                                            admin: res),
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
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        ]);
                      }).toList(),
                    ),
                  );
                }),
          ],
        ),
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
