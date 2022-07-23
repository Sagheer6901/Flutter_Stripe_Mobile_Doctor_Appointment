// ignore_for_file: camel_case_types, must_be_immutable
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outlook/constants.dart';
// import '/bottomnav.dart';
// import '/orders.dart';

class AppointmentDetails extends StatefulWidget {
  final String documentId;
  final role;
  final page;
  AppointmentDetails(
      {Key? key,
      required this.documentId,
      required this.page,
      required this.role})
      : super(key: key);

  @override
  State<AppointmentDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<AppointmentDetails> {
  var size, height, width;

  @override
  Widget build(BuildContext context) {
    // CollectionReference for worker drwaer single data
    CollectionReference users =
        FirebaseFirestore.instance.collection('appointments');
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => orderDetails()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text("Appointment Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: FutureBuilder<DocumentSnapshot>(
                  future: users.doc(widget.documentId).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something Went wrong");
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          Text("Data does not exists"),
                        ],
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            width: width * 0.5,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 4)
                                ]),
                            child: Column(
                              children: [
                                Center(
                                  child: Image(
                                    image:
                                        AssetImage("assets/images/logo1.png"),
                                    height: 80,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: Text(
                                    "${data['docname']}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                                Divider(color: Colors.grey),
                                Center(
                                  child: Text(
                                    "Appointment status: ${data['status']}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.5,
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: Colors.purple),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 1)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // ListTile(
                                //   leading: Icon(Icons.phone),
                                //   title: Text("${data['userContact']}"),
                                // ),
                                ListTile(
                                  leading: Icon(Icons.description),
                                  title: Text(
                                      "Date: ${data['date']} at ${data['time']}"),
                                ),
                                Divider(color: Colors.grey[500]),
                                ListTile(
                                  leading: Icon(Icons.euro),
                                  title: Text("\$50"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          widget.page == 'upcoming'
                              ? Row(
                                  mainAxisAlignment: widget.role == 'user'
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 10,
                                              offset: Offset(2, 2),
                                            )
                                          ]),
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        color: Colors.purple[500],
                                        height: 45,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "Back",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 3),
                                        ),
                                      ),
                                    ),
                                    widget.role == 'user'
                                        ? SizedBox(
                                            width: width * 0.1,
                                          )
                                        : SizedBox(),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 10,
                                              offset: Offset(2, 2),
                                            )
                                          ]),
                                      child: MaterialButton(
                                        onPressed: () {
                                          _showMyDialog();
                                        },
                                        color: Colors.red,
                                        height: 45,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 3),
                                        ),
                                      ),
                                    ),
                                    widget.role == 'user'
                                        ? SizedBox()
                                        : Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 3,
                                                    blurRadius: 10,
                                                    offset: Offset(2, 2),
                                                  )
                                                ]),
                                            child: MaterialButton(
                                              onPressed: () {
                                                _showCompleteDialog();
                                              },
                                              color: Colors.green,
                                              height: 45,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                "Mark Complete",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 3),
                                              ),
                                            ),
                                          ),
                                  ],
                                )
                              : SizedBox(),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to cancel this appointment?'),
                // Text(
                //     'Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Back'),
                  onPressed: () {
                    // cancelledByUser();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    cancelledByUser();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCompleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark Appointment Complete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Mark this appointment as completed?'),
                // Text(
                //     'Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Back'),
                  onPressed: () {
                    // cancelledByUser();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    completedAppointment();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future cancelledByUser() async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.documentId)
        .update({"status": "Cancelled"}).then((value) => print("Success"));
  }

  Future completedAppointment() async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.documentId)
        .update({"status": "Completed"}).then((value) => print("Success"));
  }
}
