import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishio/screens/details/recipe_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../navbars/hamburgermenu.dart';
import '../../services/database.dart';
import '../../services/firebasestorageapi.dart';
import '../../style/colors.dart';

class DishFinderScreen extends StatefulWidget {
  const DishFinderScreen({super.key});

  @override
  State<DishFinderScreen> createState() => _DishFinderScreenState();
}

class _DishFinderScreenState extends State<DishFinderScreen> {
  List<String> _selectedProducts = [];
  final _scrollController = ScrollController();

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
          "Dish finder",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Jakie produkty posiadasz??',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: DatabaseService(uid: '').ingredientCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<String> products = [];
                for (var cat in snapshot.data!.docs) {
                  products.add(cat.get('name'));
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  child: Container(
                    height: 310,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Scrollbar(
                      isAlwaysShown: true,
                      controller: _scrollController,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(products[index]),
                            value: _selectedProducts.contains(products[index]),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _selectedProducts.add(products[index]);
                                } else {
                                  _selectedProducts.remove(products[index]);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 25,
              thickness: 1,
              indent: 25,
              endIndent: 25,
            ),
            StreamBuilder(
                stream: DatabaseService(uid: '').recipeCollection.snapshots(),
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
                        List<dynamic> products = document['products'];
                        bool res = products.every(
                            (product) => _selectedProducts.contains(product));
                        if (res == false) return Container();
                        return Column(children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: FutureBuilder(
                                      future: _getImage(context, document.id),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<Widget> snapshot) {
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
                                      bool res = await DatabaseService(uid: '')
                                          .checkIfAdmin(FirebaseAuth
                                              .instance.currentUser!.uid);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RecipeDetails(
                                              id: document.id, admin: res),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      constraints: BoxConstraints.expand(),
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "~" + time + "min",
                                              style: TextStyle(fontSize: 20),
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
