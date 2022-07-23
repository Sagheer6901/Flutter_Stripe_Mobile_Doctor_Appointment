// ignore_for_file: prefer_const_constructors, unused_field

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outlook/components/customtextfield.dart';
import 'package:outlook/core/database.dart';
import '../../components/pickimage.dart';
import '../../constants.dart';
import '/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  final role;
  const SignUp({Key? key, required this.role}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID = "";

  @override
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contact = TextEditingController();
  String? image1;
  Database database = new Database();
  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static RegExp regExp = new RegExp(p);

  void vaildation() {
    if (email.text.isEmpty &&
        password.text.isEmpty &&
        username.text.isEmpty &&
        address.text.isEmpty &&
        contact.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Fleids Are Empty"),
        ),
      );
    } else if (username.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("FullName Is Empty"),
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
    } else {
      Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String? localimage;
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
                        widget.role == 'admin' ? 'Add Admin' : 'SignUp',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.role == 'admin'
                          ? SizedBox()
                          : Text(
                              'Create an Account',
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
                InkWell(
                  onTap: chooseImage,
                  child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFFEDBD0),
                      backgroundImage: localimage == null
                          ? null
                          : MemoryImage(base64Decode(localimage!)),
                      child: localimage == null
                          ? Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.black,
                            )
                          : null),
                ),
                Center(
                  child: Container(
                    height: 600,
                    width: 300,
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: 'Username',
                          label: 'name',
                          controller: username,
                          data: Icons.list,
                          isObsecure: false,
                          flag: true,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'Email Address',
                          label: 'email',
                          controller: email,
                          data: Icons.email,
                          isObsecure: false,
                          flag: true,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'Password',
                          label: 'password',
                          controller: password,
                          data: Icons.password,
                          isObsecure: true,
                          flag: true,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'Address',
                          label: 'Address',
                          controller: address,
                          data: Icons.input,
                          isObsecure: false,
                          flag: true,
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.all(10.0),
                          child: TextFormField(
                              maxLength: 11,
                              controller: contact,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                label: Text('contact'),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: kTitleTextColor,
                                ),
                                focusColor: kPrimaryColor,
                                hintText: 'Contact',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-zA-Z]")),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Container(
                    height: 50,
                    width: 300,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      color: kPrimaryColor,
                      child: Text(
                        widget.role == 'admin' ? 'Add Admin' : 'SignUp',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        vaildation();
                        widget.role == 'admin'
                            ? database
                                .postDetailsToFirestore(
                                    localimage!,
                                    email.text,
                                    password.text,
                                    username.text,
                                    address.text,
                                    contact.text,
                                    widget.role)
                                .then((_) {
                                widget.role == 'admin'
                                    ? Navigator.of(context).pop()
                                    : Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Login(
                                                  role: widget.role,
                                                )))
                                        .then((_) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Registered Successfully now you can login",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 3,
                                            backgroundColor: kPrimaryColor,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      });
                              })
                            : database
                                .postUserDetailsToFirestore(
                                    localimage,
                                    email.text,
                                    password.text,
                                    username.text,
                                    address.text,
                                    contact.text,
                                    widget.role)
                                .then((_) {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => Login(
                                              role: widget.role,
                                            )))
                                    .then((_) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Registered Successfully now you can login",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: kPrimaryColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                              });
                      },
                    ),
                  ),
                ),
                widget.role == 'admin'
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have Acccount?'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login(
                                              role: widget.role,
                                            )));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 15,
                                ),
                              ))
                        ],
                      ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  var data;
  void chooseImage() async {
    localimage = await pickImage();
    setState(() {});
    if (localimage != null)
      image:
      localimage;
  }
}
