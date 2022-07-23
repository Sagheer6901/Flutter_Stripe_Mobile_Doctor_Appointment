// ignore_for_file: prefer_const_constructors, unused_field, unrelated_type_equality_checks
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outlook/components/customtextfield.dart';
import 'package:outlook/constants.dart';
import 'package:outlook/core/database.dart';
import 'package:outlook/screens/auth/navscreen.dart';
import 'package:outlook/screens/auth/signup.dart';
import 'package:outlook/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final role;
  const Login({Key? key, required this.role}) : super(key: key);

  @override
  State<Login> createState() => _SignUpState();
}

class _SignUpState extends State<Login> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID = "";

  @override
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String? image1;
  Database database = new Database();
  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static RegExp regExp = new RegExp(p);

  String? errorMessage;

  Future vaildation() async {
    if (email.text.isEmpty && password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Fleids Are Empty"),
        ),
      );
    } else if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Not Vaild"),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Is Too Short"),
        ),
      );
    }
  }

// var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                  height: 210,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 25,
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 127,
                          width: 230,
                          child: Image(
                            image: AssetImage(
                              'assets/images/logo3.png',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    height: 250,
                    width: 300,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: email,
                          data: Icons.email,
                          hintText: 'Enter your email',
                          label: 'Email',
                          isObsecure: false,
                          flag: true,
                        ),

                        // mytextformfield('Email Address', 'email', email,
                        // Icon(Icons.email), false),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: password,
                          data: Icons.password,
                          hintText: 'Enter your password',
                          label: 'Password',
                          isObsecure: true,
                          flag: true,
                        )
                        // mytextformfield('Password', 'password', password,
                        //     Icon(Icons.remove_red_eye), true),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Container(
                    height: 50,
                    width: 300,
                    child: isloading == true
                        ? Center(child: CircularProgressIndicator())
                        : RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            color: kPrimaryColor,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              vaildation().then((_) {
                                login();
                              });
                            },
                          ),
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                widget.role == 'admin'
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Didn\'t have Acccount?'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp(
                                              role: widget.role,
                                            )));
                              },
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                  // color: Colors.blue[800],
                                  color: kPrimaryColor,
                                  fontSize: 15,
                                ),
                              ))
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  var data;
  bool isloading = false;
  login() async {
    try {
      setState(() {
        isloading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .whenComplete(() {
        setState(() {
          isloading = false;
        });
      }).then((value) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('email', email.text);
        preferences.setString('role', widget.role);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                NavScreen(email: email.text, role: widget.role)));
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(e.code);
    }
  }
}
