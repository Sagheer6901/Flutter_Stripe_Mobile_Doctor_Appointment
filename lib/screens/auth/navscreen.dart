import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlook/screens/main/main_screen.dart';

class NavScreen extends StatelessWidget {
  final email;
  final role;
  const NavScreen({Key? key, required this.email, required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: currentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(role)
                .where('email', isEqualTo: email) // or uid
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.length > 0) {
                  if (snapshot.data!.docs[0]["role"] == role) {
                    return MainScreen(role: role);
                  } else {
                    throw Exception();
                  }
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('you are not $role')));
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }
        return Container();
      },
    ));
  }
}

Future<User> currentUser() async {
  FirebaseAuth _firebaseInstance = FirebaseAuth.instance;
  return _firebaseInstance.currentUser!;
}
