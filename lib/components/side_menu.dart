import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlook/appointmenthistorypage.dart';
import 'package:outlook/cancelledappointmentpage.dart';
import 'package:outlook/responsive.dart';
import 'package:outlook/screens/Welcome/home.dart';
import 'package:outlook/screens/addDocScreen.dart';
import 'package:outlook/screens/adddoctor.dart';
import 'package:outlook/screens/auth/addadminScreen.dart';
import 'package:outlook/screens/auth/signup.dart';
import 'package:outlook/screens/main/main_screen.dart';
import 'package:outlook/upcomingappointmentspage.dart';
import 'package:outlook/updateprofilescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../screens/Welcome/welcome_screen.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

bool home = true;
bool addDoc = false;
bool appHistory = false;
bool appcancelled = false;
bool upcomingappointment = false;
bool editprofile = false;
bool addadmin = false;

class _SideMenuState extends State<SideMenu> {
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
                    width: 140,
                    height: 70,
                  ),
                  Spacer(),
                  // We don't want to show this close button on Desktop mood
                  if (!Responsive.isDesktop(context)) CloseButton(),
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
                  upcomingappointment = false;
                  editprofile = false;
                  addadmin = false;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MainScreen(role: 'admin')));
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
                  upcomingappointment = false;
                  editprofile = false;
                  addadmin = false;

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddDocScreen()));
                },
                title: "Add a doctor",
                iconSrc: "assets/Icons/Plus.svg",
                isActive: addDoc,
              ),
              SideMenuItem(
                press: () {
                  addDoc = false;
                  home = false;
                  appHistory = true;
                  appcancelled = false;
                  upcomingappointment = false;
                  editprofile = false;
                  addadmin = false;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AppointmentHistoryPage(role: 'admin')));
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
                  upcomingappointment = false;
                  editprofile = false;
                  addadmin = false;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CancelledAppointmentPage(
                            role: 'admin',
                          )));
                },
                title: "Cancelled Appointments",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: appcancelled,
                showBorder: false,
              ),
              SideMenuItem(
                press: () {
                  addDoc = false;
                  home = false;
                  appHistory = false;
                  appcancelled = false;
                  upcomingappointment = true;
                  editprofile = false;
                  addadmin = false;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          UpcomigAppointmentPage(role: 'admin')));
                },
                title: "Upcoming Appointments",
                iconSrc: "assets/Icons/Markup.svg",
                isActive: upcomingappointment,
              ),
              SideMenuItem(
                press: () {
                  addDoc = false;
                  home = false;
                  appHistory = false;
                  appcancelled = false;
                  upcomingappointment = false;
                  editprofile = false;
                  addadmin = true;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddAdminPage(role: 'admin')));
                },
                title: "Add admin",
                iconSrc: "assets/Icons/Plus.svg",
                isActive: addadmin,
              ),
              SideMenuItem(
                press: () {
                  addDoc = false;
                  home = false;
                  appHistory = false;
                  appcancelled = false;
                  upcomingappointment = false;
                  editprofile = true;
                  addadmin = false;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfilePage(role: 'admin')));
                },
                title: "Edit Profile",
                iconSrc: "assets/Icons/Edit.svg",
                isActive: editprofile,
              ),
              SideMenuItem(
                press: () async {
                  addDoc = false;
                  home = false;
                  appHistory = false;
                  appcancelled = false;
                  upcomingappointment = false;
                  editprofile = false;
                  addadmin = false;

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
              ),
              SizedBox(height: kDefaultPadding * 2),
            ],
          ),
        ),
      ),
    );
  }
}
