// ignore_for_file: deprecated_member_use, file_names, prefer_const_constructors, unused_label, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outlook/constants.dart';
import 'package:outlook/screens/adddoctor.dart';
import 'package:outlook/screens/main/main_screen.dart';

class EditProfile extends StatefulWidget {
  final role;
  const EditProfile({required this.role});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String localmage = '';
  TextEditingController usernamee = TextEditingController();
  TextEditingController contactt = TextEditingController();
  TextEditingController addresss = TextEditingController();
  TextEditingController image = TextEditingController();
  bool showPassword = false;
  @override
  void initState() {
    // TODO: implement initState
    getUserData().then((value) {
      setState(() {
        data = value;
        localmage = data['image'];
      });
    }).whenComplete(() {
      setState(() {});
    });
  }

  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: ListView(
                children: [
                  Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        localmage.isNotEmpty
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    MemoryImage(base64Decode(localmage)),
                              )
                            : data['image'] != 'abcd'
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        MemoryImage(base64Decode(data[image])))
                                : const CircleAvatar(
                                    radius: 50,
                                  ),
                        InkWell(
                          onTap: () {
                            chooseImage();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: kPrimaryColor,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        buildTextField(
                            "Full Name", data['username'], false, usernamee),
                        SizedBox(
                          height: 25,
                        ),
                        buildTextField(
                            "Address", data['address'], false, addresss),
                        SizedBox(
                          height: 25,
                        ),
                        buildTextField(
                            "Contact", data['contact'], true, contactt),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          // updatedata();
                          updateData(widget.role).then((_) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MainScreen(role: widget.role)));
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Profile Updated')));
                          });
                        },
                        color: kPrimaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainScreen(role: widget.role)));
                        },
                        color: kPrimaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Back",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Future updateData(String role) async {
    FirebaseFirestore.instance
        .collection(role)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
        'image': localmage,
        'username': usernamee.text == "" ? data['username'] : usernamee.text,
        'address': addresss.text == "" ? data['address'] : addresss.text,
        'contact': contactt.text == "" ? data['contact'] : contactt.text
      },
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, TextEditingController ctrl) {
    return Padding(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.15, 0,
          MediaQuery.of(context).size.width * 0.15, 0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        controller: ctrl,
      ),
    );
  }

  void chooseImage() async {
    localmage = await pickImage();
    setState(() {});
    if (localmage != null)
      image:
      localmage;
  }

  Future<String> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _imagePicker =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (_imagePicker != null) {
      Uint8List bytes = await _imagePicker.readAsBytes();

      String encode = base64Encode(bytes);

      return encode;
    } else {
      if (kDebugMode) {
        print('Pick Image First');
      }
      return 'Error';
    }
  }

  Future getUserData() async {
    return await FirebaseFirestore.instance
        .collection(widget.role)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
}
