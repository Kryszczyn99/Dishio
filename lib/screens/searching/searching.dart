import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../navbars/hamburgermenu.dart';
import '../../services/database.dart';
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
        backgroundColor: MyColors.color6,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Searching",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                stream: DatabaseService(uid: '').categoryCollection.snapshots(),
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

              // Search button
              const SizedBox(height: 125),
              Container(
                height: 56.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: [Colors.red, MyColors.color6],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
