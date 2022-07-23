import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outlook/components/side_menu.dart';
import 'package:outlook/components/user_side_menu.dart';
import 'package:outlook/responsive.dart';
import 'package:outlook/screens/doctor_details.dart';
import 'package:outlook/screens/email/email_screen.dart';
import '../doc_profile.dart';
import 'components/list_of_emails.dart';

class MainScreen extends StatelessWidget {
  final role;
  MainScreen({required this.role});
  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= Duration(seconds: 2);
          pre_backpress = DateTime.now();
          if (cantExit) {
            //show snackbar
            final snack = SnackBar(
              content: Text('Press Back button again to Exit'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snack);
            return false;
          } else {
            exit(0);
          }
        },
        child: Responsive(
          // Let's work on our mobile part
          mobile: ListOfEmails(
            role: role,
          ),
          tablet: Row(
            children: [
              Expanded(
                flex: 6,
                child: ListOfEmails(role: role),
              ),
            ],
          ),
          desktop:
              // Row(
              //   children: [
              //     // Once our width is less then 1300 then it start showing errors
              //     // Now there is no error if our width is less then 1340
              //     Expanded(
              //       flex: 1,
              //       // flex: _size.width > 1340 ? 2 : 4,
              //       child: role == 'admin' ? SideMenu() : UserSideMenu(),
              //     ),
              //     Expanded(
              //       flex: 4,
              //       // flex: _size.width > 1340 ? 3 : 5,
              //       child: ListOfEmails(role: role),
              //     ),
              //     // Expanded(
              //     //   // flex: _size.width > 1340 ? 8 : 10,
              //     //   // child: role == 'admin' ? EmailScreen() : DoctorProfile(),
              //     // ),
              //   ],
              // ),
              ListOfEmails(
            role: role,
          ),
        ),
      ),
    );
  }
}
