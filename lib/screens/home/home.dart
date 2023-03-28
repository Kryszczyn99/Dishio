import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:dishio/style/colors.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Siema"),
    );
  }
}
