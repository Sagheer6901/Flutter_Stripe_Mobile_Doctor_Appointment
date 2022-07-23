import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlook/appointmenthistory.dart';
import 'package:outlook/cancelledappointmentpage.dart';
import 'package:outlook/cancelledappointments.dart';
import 'package:outlook/responsive.dart';
import 'package:outlook/screens/Welcome/welcome_screen.dart';
import 'package:outlook/screens/addDocScreen.dart';
import 'package:outlook/screens/adddoctor.dart';
import 'package:outlook/screens/main/main_screen.dart';
import 'package:outlook/upcomingappointments.dart';
import 'package:outlook/upcomingappointmentspage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../appointmenthistorypage.dart';
import '../constants.dart';
import '../screens/Welcome/home.dart';
import '../updateprofilescreen.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class UserSideMenu extends StatefulWidget {
  const UserSideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<UserSideMenu> createState() => _UserSideMenu();
}

bool home = true;
bool addDoc = false;
bool appHistory = false;
bool appcancelled = false;
bool editprofile = false;

class _UserSideMenu extends State<UserSideMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/logo3.png",
                    width: 175,
                    height: 100,
                  ),
                  // We don't want to show this close button on Desktop mood
                ],
              ),
              SizedBox(height: kDefaultPadding),

              // Menu Items
              SideMenuItem(
                press: () {
                  addDoc = false;
                  home = true;
                  appHistory = false;
                  appcancelled = false;
                  editprofile = false;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MainScreen(role: 'user')));
                },
                title: "Home",
                iconSrc: "assets/Icons/Inbox.svg",
                isActive: home,
                itemCount: 3,
              ),
              SideMenuItem(
                press: () {
                  addDoc = true;
                  home = false;
                  appHistory = false;
                  appcancelled = false;
                  editprofile = false;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpcomigAppointmentPage(
                            role: 'user',
                          )));
                },
                title: "Upcoming Appointments",
                iconSrc: "assets/Icons/Markup.svg",
                isActive: addDoc,
              ),
              SideMenuItem(
                press: () {
                  addDoc = false;
                  home = false;
                  appHistory = true;
                  appcancelled = false;
                  editprofile = false;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AppointmentHistoryPage(
                            role: 'user',
                          )));
                },
                title: "Appointments History",
                iconSrc: "assets/Icons/File.svg",
                isActive: appHistory,
              ),
              SideMenuItem(
                press: () {
                  addDoc = false;
                  home = false;
                  appHistory = false;
                  appcancelled = true;
                  editprofile = false;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CancelledAppointmentPage(role: 'user')));
                },
                title: "Cancelled Appointments",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: appcancelled,
                showBorder: false,
              ),

              SideMenuItem(
                press: () {
                  editprofile = true;
                  home = false;
                  appHistory = false;
                  appcancelled = false;
                  addDoc = false;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                            role: 'user',
                          )));
                },
                title: "Profile",
                iconSrc: "assets/Icons/Edit.svg",
                isActive: editprofile,
              ),

              SideMenuItem(
                press: () async {
                  addDoc = false;
                  home = false;
                  appHistory = false;
                  appcancelled = false;
                  editprofile = false;

                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()),
                      ModalRoute.withName('/login'));
                },
                title: "Logout",
                iconSrc: "assets/Icons/Reply.svg",
                isActive: false,
                showBorder: false,
              ),

              SizedBox(height: kDefaultPadding * 2),
            ],
          ),
        ),
      ),
    );
  }
}
