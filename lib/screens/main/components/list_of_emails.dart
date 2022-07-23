import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outlook/components/side_menu.dart';
import 'package:outlook/components/user_side_menu.dart';
import 'package:outlook/models/Email.dart';
import 'package:outlook/responsive.dart';
import 'package:outlook/screens/doc_profile.dart';
import 'package:outlook/screens/email/email_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import 'email_card.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ListOfEmails extends StatefulWidget {
  // Press "Command + ."
  ListOfEmails({
    required this.role,
    Key? key,
  }) : super(key: key);
  String role;
  @override
  _ListOfEmailsState createState() => _ListOfEmailsState();
}

class _ListOfEmailsState extends State<ListOfEmails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: widget.role == 'admin' ? SideMenu() : UserSideMenu(),
      ),
      body: Container(
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Seearch bar
              Container(
                color: kBgLightColor,
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // Once user click the menu icon the menu shows like drawer
                    // Also we want to hide this menu icon on desktop
                    // if (!Responsive.isDesktop(context))
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                    Image(
                      image: AssetImage('assets/images/logo3.png'),
                      height: 60,
                      width: 200,
                      fit: BoxFit.fill,
                    )
                  ],
                ),
              ),
              Text(
                'Registered Doctor',
                style: TextStyle(fontSize: 20),
              ),
              Divider(),

              SizedBox(height: kDefaultPadding),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: doctorStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Oops! An error has occured'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data!.size == 0) {
                        return Center(
                            child: Text(
                                'No available Doctors or No internet connection'));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => EmailCard(
                          isActive:
                              Responsive.isMobile(context) ? false : index == 0,
                          email: Email(
                              time:
                                  'From ${snapshot.data!.docs[index]['from']}\n To ${snapshot.data!.docs[index]['to']}',
                              isChecked: true,
                              image: snapshot.data!.docs[index]['image'],
                              name: snapshot.data!.docs[index]['name'],
                              shortinfo: snapshot.data!.docs[index]
                                  ['shortinfo'],
                              subject: snapshot.data!.docs[index]['category'],
                              body: snapshot.data!.docs[index]['days'],
                              experience: snapshot.data!.docs[index]
                                  ['experience'],
                              isAttachmentAvailable: false,
                              tagColor: kPrimaryColor),
                          docid: snapshot.data!.docs[index].id,
                          press: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DoctorProfile(
                                    role: widget.role,
                                    docid: snapshot.data!.docs[index].id),
                              ),
                            );
                          },
                          role: widget.role,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final Stream<QuerySnapshot> doctorStream =
      FirebaseFirestore.instance.collection('doctor').snapshots();
}
