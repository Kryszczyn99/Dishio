import 'package:dishio/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UsersTableScreen extends StatefulWidget {
  const UsersTableScreen({super.key});

  @override
  State<UsersTableScreen> createState() => _UsersTableScreenState();
}

class _UsersTableScreenState extends State<UsersTableScreen> {
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
          "Users Table",
          style: TextStyle(fontSize: 34, fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Text("Test"),
        ),
      ),
    );
  }
}
