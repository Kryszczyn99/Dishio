import 'package:dishio/screens/home/home.dart';
import 'package:dishio/screens/profile/editing.dart';
import 'package:dishio/services/auth.dart';
import 'package:dishio/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../services/database.dart';

class Register extends StatefulWidget {
  //const Register({Key? key}) : super(key: key);

  final Function changeView;
  const Register({required this.changeView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var uuid = Uuid();
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
  String pass2 = '';
  String err = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: MyColors.color10,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: (MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.height),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 30.0),
                    Container(
                      height: 230.0,
                      width: 230.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/dish-icon.png'),
                        ),
                      ),
                    ),
                    const Text(
                      "Dishio",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 42,
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      height: 45,
                      thickness: 2,
                      indent: 25,
                      endIndent: 25,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        fillColor: MyColors.color6.withOpacity(0.7),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 20, top: 15),
                        hintText: 'Email',
                        suffixIcon:
                            Icon(Icons.email, color: Colors.white, size: 25.0),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        fillColor: MyColors.color6.withOpacity(0.7),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 20, top: 15),
                        hintText: 'Password',
                        suffixIcon:
                            Icon(Icons.lock, color: Colors.white, size: 25.0),
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 8
                          ? 'Enter a password 8+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() => pass = val);
                      },
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        fillColor: MyColors.color6.withOpacity(0.7),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 20, top: 15),
                        hintText: 'Confirm password',
                        suffixIcon:
                            Icon(Icons.lock, color: Colors.white, size: 25.0),
                      ),
                      obscureText: true,
                      validator: (val) {
                        if (val != pass) {
                          return 'Password must be the same';
                        } else if (val!.length < 8) {
                          return 'Enter a password 8+ chars long';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() => pass2 = val);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      err,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(MyColors.color6),
                          minimumSize: MaterialStateProperty.all(Size(140, 35)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic resValue =
                              await authService.registerUser(email, pass);
                          if (resValue == null) {
                            setState(
                                () => err = 'Give valid email or password');
                          } else {
                            var uid = uuid.v4();
                            await DatabaseService(uid: '').createStatsForUser(
                                FirebaseAuth.instance.currentUser!.uid, uid);
                          }
                        }
                      },
                      child: Text('Register'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.changeView();
                      },
                      child: Text('Click here to login!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
