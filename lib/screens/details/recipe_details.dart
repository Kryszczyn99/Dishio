import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:uuid/uuid.dart';

import '../../navbars/hamburgermenu.dart';
import '../../services/database.dart';
import '../../services/firebasestorageapi.dart';
import '../../style/colors.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({required this.id});

  final String id;

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  final _controller = PageController();
  int _currentPage = 0;
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color8,
      appBar: AppBar(
        backgroundColor: MyColors.color6,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Dishio",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Text('Zgłoś przepis'),
                value: 'report_recipe',
              ),
            ],
            onSelected: (value) {
              if (value == 'report_recipe') {
                //tutaj do zrobienia reportowanie przepisu
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Center(
          child: Column(
            children: [
              FutureBuilder(
                  future: _getImage(context, widget.id),
                  builder:
                      (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    return Container(
                      child: snapshot.data,
                    );
                  }),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('recipesTable')
                    .doc(widget.id)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  String title = snapshot.data!.get("title");
                  String time = snapshot.data!.get("time");
                  String productDesp = snapshot.data!.get("product_desp");
                  String desp = snapshot.data!.get("desp");

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.schedule),
                            SizedBox(width: 4.0),
                            Text(
                              '$time min',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Pacifico',
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                StreamBuilder(
                                    stream: DatabaseService(uid: '')
                                        .likeCollection
                                        .where('user_id',
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .where('recipe_id',
                                            isEqualTo: widget.id)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            snapshot2) {
                                      if (!snapshot2.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return StreamBuilder(
                                        stream: DatabaseService(uid: '')
                                            .likeCollection
                                            .where('recipe_id',
                                                isEqualTo: widget.id)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot3) {
                                          if (!snapshot3.hasData) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          int len = 0;
                                          for (var temp
                                              in snapshot3.data!.docs) {
                                            len = len + 1;
                                          }
                                          bool value = false;
                                          for (var temp
                                              in snapshot2.data!.docs) {
                                            if (temp.get('user_id') ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid &&
                                                temp.get('recipe_id') ==
                                                    widget.id) value = true;
                                          }
                                          if (value == true) {
                                            return TextButton.icon(
                                              onPressed: () async {
                                                await DatabaseService(uid: '')
                                                    .cancelLike(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        widget.id);
                                              },
                                              icon: Icon(
                                                Icons.thumb_up,
                                              ),
                                              label: Text(
                                                "$len",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            );
                                          }
                                          return TextButton.icon(
                                            onPressed: () async {
                                              var generated_id = uuid.v4();

                                              await DatabaseService(uid: '')
                                                  .giveLike(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      generated_id,
                                                      widget.id);
                                              await DatabaseService(uid: '')
                                                  .cancelDisLike(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.id);
                                            },
                                            icon: Icon(
                                              Icons.thumb_up,
                                              color: Colors.black,
                                            ),
                                            label: Text(
                                              "$len",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ],
                            ),
                            SizedBox(width: 16.0),
                            Row(
                              children: [
                                StreamBuilder(
                                    stream: DatabaseService(uid: '')
                                        .dislikeCollection
                                        .where('user_id',
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .where('recipe_id',
                                            isEqualTo: widget.id)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            snapshot2) {
                                      if (!snapshot2.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return StreamBuilder(
                                        stream: DatabaseService(uid: '')
                                            .dislikeCollection
                                            .where('recipe_id',
                                                isEqualTo: widget.id)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot3) {
                                          if (!snapshot3.hasData) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          int len = 0;
                                          for (var temp
                                              in snapshot3.data!.docs) {
                                            len = len + 1;
                                          }
                                          bool value = false;
                                          for (var temp
                                              in snapshot2.data!.docs) {
                                            if (temp.get('user_id') ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid &&
                                                temp.get('recipe_id') ==
                                                    widget.id) value = true;
                                          }
                                          if (value == true) {
                                            return TextButton.icon(
                                              onPressed: () async {
                                                await DatabaseService(uid: '')
                                                    .cancelDisLike(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        widget.id);
                                              },
                                              icon: Icon(
                                                Icons.thumb_down,
                                              ),
                                              label: Text(
                                                "$len",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            );
                                          }
                                          return TextButton.icon(
                                            onPressed: () async {
                                              var generated_id = uuid.v4();
                                              await DatabaseService(uid: '')
                                                  .giveDisLike(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      generated_id,
                                                      widget.id);
                                              await DatabaseService(uid: '')
                                                  .cancelLike(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.id);
                                            },
                                            icon: Icon(
                                              Icons.thumb_down,
                                              color: Colors.black,
                                            ),
                                            label: Text(
                                              "$len",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Ingredients:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          productDesp,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Divider(
                        thickness: 1.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Preparation:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          desp,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }

  Future<Widget> _getImage(BuildContext context, String id) async {
    late Widget image;
    List<Widget> images = [];

    try {
      var storageRef = FirebaseStorage.instance.ref("images/$id");
      ListResult temp = await storageRef.listAll();
      int i = 0;
      for (var item in temp.items) {
        String path = item.fullPath.toString();
        i += 1;
        await FirebaseApi.loadImage(context, path).then((value) {
          image = Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 2.0, color: Colors.black),
                bottom: BorderSide(width: 2.0, color: Colors.black),
              ),
              image: DecorationImage(
                image: NetworkImage(value.toString()),
                fit: BoxFit.cover,
              ),
            ),
          );
          images.add(image);
        });
      }
      image = Column(children: [
        Container(
            width: double.infinity,
            height: 200,
            child: PageView(
              controller: _controller,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: images,
            )),
        Container(
          color: Colors.white,
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(i, (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.black : Colors.grey,
                ),
              );
            }),
          ),
        ),
      ]);
    } catch (err) {
      return Scaffold();
    }
    return image;
  }
}
