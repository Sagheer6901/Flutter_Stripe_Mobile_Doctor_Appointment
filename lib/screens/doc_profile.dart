import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outlook/models/Email.dart';
import 'package:outlook/screens/docappointmenthistory.dart';
import 'package:outlook/screens/doctor_details.dart';
import 'package:outlook/screens/editdoc.dart';
import 'package:outlook/testbooking.dart';
import '../../constants.dart';

class DoctorProfile extends StatefulWidget {
  final docid;
  final role;
  DoctorProfile({Key? key, required this.docid, required this.role})
      : super(key: key);

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((value) {
      setState(() {
        data = value;
      });
    });
    print(widget.docid);
  }

  var data;
  @override
  Widget build(BuildContext context) {
    return data == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Color.fromRGBO(33, 45, 82, 1),
                ),
              ),
              title: Text(
                widget.role == null ? 'Provider' : "Doctor Profile",
                style: TextStyle(
                  color: Color.fromRGBO(33, 45, 82, 1),
                ),
              ),
            ),
            body: Container(
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: MemoryImage(base64Decode(data['image'])),
                                fit: BoxFit.scaleDown))),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(kDefaultPadding),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              maxRadius: 24,
                              backgroundColor: Colors.transparent,
                              backgroundImage: AssetImage(
                                data['image'],
                              ),
                            ),
                            SizedBox(width: kDefaultPadding),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${data['name']} (proficient in:${data['Proficiency'] == 'Both' ? 'English,Spanish' : data['Proficiency']})',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: kDefaultPadding / 2),
                                    ],
                                  ),
                                  SizedBox(height: kDefaultPadding),
                                  LayoutBuilder(
                                    builder: (context, constraints) => SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            data['desc'],
                                            style: TextStyle(
                                              height: 1.5,
                                              color: Color(0xFF4D5875),
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          SizedBox(height: kDefaultPadding),
                                          widget.role == null
                                              ? SizedBox()
                                              : widget.role == 'user'
                                                  ? Container(
                                                      height: 50,
                                                      width: 200,
                                                      margin: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.1),
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      kPrimaryColor),
                                                          onPressed: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            BookingScreen(
                                                                              data: data,
                                                                              docid: widget.docid,
                                                                            )));
                                                          },
                                                          child: Text(
                                                              'Book Appointment')))
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          height: 50,
                                                          width: 200,
                                                          margin: EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.1),
                                                          child: ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          kPrimaryColor),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (context) => DocAppointmentHistory(
                                                                              docid: widget.docid,
                                                                              role: widget.role,
                                                                            )));
                                                              },
                                                              child: Text(
                                                                  'View Appointments')),
                                                        ),
                                                        Container(
                                                          height: 50,
                                                          width: 200,
                                                          margin: EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.1),
                                                          child: ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary: Colors
                                                                              .green[
                                                                          400]),
                                                              onPressed: () {
                                                                Navigator.of(context).push(MaterialPageRoute(
                                                                    builder: (context) => EditDoctor(
                                                                        docid: widget
                                                                            .docid,
                                                                        docdata:
                                                                            data)));
                                                              },
                                                              child: Text(
                                                                  'Edit Doctor')),
                                                        ),
                                                        Container(
                                                          height: 50,
                                                          width: 200,
                                                          margin: EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.1),
                                                          child: ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary: Colors
                                                                              .red[
                                                                          400]),
                                                              onPressed: () {
                                                                delete()
                                                                    .then((_) {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "Deleted Doctor's record Successfully",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity: ToastGravity
                                                                          .BOTTOM,
                                                                      timeInSecForIosWeb:
                                                                          3,
                                                                      backgroundColor:
                                                                          kPrimaryColor,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          16.0);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                              },
                                                              child: Text(
                                                                  'Delete Doctor')),
                                                        ),
                                                      ],
                                                    )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future getData() async {
    return await FirebaseFirestore.instance
        .collection('doctor')
        .doc(widget.docid)
        .get();
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance
          .collection("doctor")
          .doc(widget.docid)
          .delete();
    } catch (e) {
      print(e);
    }
  }
}
