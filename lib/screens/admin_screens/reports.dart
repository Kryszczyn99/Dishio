import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../style/colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
          "Reports",
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
