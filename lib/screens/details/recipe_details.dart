import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../navbars/hamburgermenu.dart';
import '../../services/firebasestorageapi.dart';
import '../../style/colors.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  Future<Widget> _getImage(BuildContext context, String id) async {
    late Widget image;
    List<Widget> images = [];
    try {
      var storageRef = FirebaseStorage.instance.ref("images/$id");
      ListResult temp = await storageRef.listAll();
      String path = temp.items.first.fullPath.toString();
      int len = temp.items.length;
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
        for (int i = 0; i < len; i++) {
          images.add(image);
        }
        image = Container(
            width: double.infinity,
            height: 200,
            child: PageView(
              children: images,
            ));
      });
    } catch (err) {
      return Scaffold();
    }
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color10,
      appBar: AppBar(
        backgroundColor: MyColors.color6,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Dishio",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
      ),
      body: FutureBuilder(
          future: _getImage(context, "61f2defe-3313-4b1a-a6b8-d753353b4450"),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            return Container(
              child: snapshot.data,
            );
          }),
    );
  }
}
