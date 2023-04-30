import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:uuid/uuid.dart';

import '../../services/database.dart';
import '../../style/colors.dart';

class CategoryAddScreen extends StatefulWidget {
  const CategoryAddScreen({super.key});

  @override
  State<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  String text = "";
  var uuid = Uuid();
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
          "Add category",
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
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.color8,
                    hintText: 'Type category',
                    hintStyle: TextStyle(color: Colors.black),
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
                ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(140, 35)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)))),
                  onPressed: () async {
                    var uid = uuid.v4();
                    await DatabaseService(uid: '').addCategory(uid, text);
                    print(text);
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context).pop(true);
                          });
                          return AlertDialog(
                            title: Text(
                              'Added category!',
                              textAlign: TextAlign.center,
                            ),
                          );
                        });
                  },
                  child: Text('Add category'),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  color: MyColors.color5,
                  thickness: 1,
                ),
                StreamBuilder(
                    stream:
                        DatabaseService(uid: '').categoryCollection.snapshots(),
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
                            if (document['name'] != "Wszystkie") {}
                            return Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 4 / 5,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 30),
                                  decoration: BoxDecoration(
                                      color: MyColors.color6.withOpacity(0.8),
                                      border: Border.all(
                                          width: 3,
                                          color:
                                              MyColors.color4.withOpacity(0.8)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_sharp,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "${document['name']}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton.icon(
                                          onPressed: () async {
                                            await DatabaseService(uid: '')
                                                .deleteCategory(document.id);
                                          },
                                          icon: Icon(
                                            Icons.restore_from_trash_sharp,
                                            color: Colors.red,
                                          ),
                                          label: Text(
                                            "",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
