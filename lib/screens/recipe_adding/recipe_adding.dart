import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../navbars/hamburgermenu.dart';
import '../../services/database.dart';
import '../../style/colors.dart';

class RecipeAdd extends StatefulWidget {
  const RecipeAdd({super.key});

  @override
  State<RecipeAdd> createState() => _RecipeAddState();
}

class _RecipeAddState extends State<RecipeAdd> {
  String? _selectedCategory;
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
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
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
                        SizedBox(height: 20),
                        Container(
                          width: 400,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: 'Czas wykonania',
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
                              // Do something with the input value
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 400,
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
                              // Do something with the input value
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          width: 400,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Do something when the button is pressed
                            },
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyColors.color6),
                              minimumSize:
                                  MaterialStateProperty.all(Size(160, 40)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              )),
                            ),
                            onPressed: () async {},
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
