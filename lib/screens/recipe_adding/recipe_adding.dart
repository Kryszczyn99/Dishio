import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../navbars/hamburgermenu.dart';
import '../../services/database.dart';
import '../../style/colors.dart';

class RecipeAdd extends StatefulWidget {
  const RecipeAdd({super.key});

  @override
  State<RecipeAdd> createState() => _RecipeAddState();
}

class _RecipeAddState extends State<RecipeAdd> {
  var uuid = Uuid();

  String? _selectedCategory;
  List<String> _selectedProducts = [];
  String products_description = "";
  String description = "";
  String time = "";
  String title = "";

  List<XFile>? _images = [];

  late FirebaseStorage storage;
  late Reference ref;

  @override
  void initState() {
    super.initState();
    storage = FirebaseStorage.instance;
    ref = storage.ref().child('images');
  }

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    setState(() {
      _images = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HamburgerMenu(),
      backgroundColor: MyColors.color8,
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
          "Add dish",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
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
                    catArray.remove("Wszystkie");

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
                            hint: Text(
                              'Wybierz kategorię',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                SizedBox(height: 20),
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Czas wykonania (min)',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      time = value;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tytuł',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Lista produktów',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      products_description = value;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Lista produktów',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      InkWell(
                        child: Icon(Icons.help_outline),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Dlaczego to jest potrzebne?'),
                                content: Text(
                                    'Lista produktów działa jak TAGi pomaga innych użytkownikom w szukaniu przepisów na podstawie posiadanych produktów.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Zamknij'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                StreamBuilder(
                  stream:
                      DatabaseService(uid: '').ingredientCollection.snapshots(),
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
                    return Container(
                      height: 200,
                      child: ListView.builder(
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
                    );
                  },
                ),
                SizedBox(height: 20),
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Opis przepisu',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 400,
                  child: ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: Icon(Icons.photo),
                    label: Text('Dodaj zdjęcie'),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 400,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Do something when the button is pressed
                    },
                    icon: Icon(Icons.list),
                    label: Text('Zaprojektuj instrukcje'),
                  ),
                ),
                SizedBox(height: 100.0),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MyColors.color6),
                      minimumSize: MaterialStateProperty.all(Size(160, 40)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                    ),
                    onPressed: () async {
                      var uid = uuid.v4();
                      Reference userRef = ref.child(uid);
                      await DatabaseService(uid: "").setRecipeInformation(
                          uid,
                          _selectedCategory!,
                          _selectedProducts,
                          title,
                          time,
                          products_description,
                          description);

                      for (var temp in _images!) {
                        File file = File(temp.path);
                        String fileName = path.basename(file.toString());
                        Reference imageRef = userRef.child(fileName);
                        await imageRef.putFile(file);
                        String imageUrl = await imageRef.getDownloadURL();
                      }
                    },
                    child: Text(
                      'Dodaj przepis',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
