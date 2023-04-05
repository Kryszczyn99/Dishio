import 'package:dishio/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:dishio/style/colors.dart';

class Login extends StatefulWidget {
  final Function changeView;
  // ignore: use_key_in_widget_constructors
  const Login({required this.changeView});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
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
                      validator: (val) => val!.length < 8
                          ? 'Enter a password 8+ chars long'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => pass = val);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      err,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 40.0,
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
                              await authService.loginUser(email, pass);
                          if (resValue == null) {
                            setState(
                                () => err = 'Give valid email or password');
                          }
                        }
                      },
                      child: Text('Login'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.changeView();
                      },
                      child: Text('Click here to register!',
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
