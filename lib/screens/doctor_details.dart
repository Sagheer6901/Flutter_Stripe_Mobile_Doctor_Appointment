import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:outlook/controller/buttoncontroller.dart';
import 'package:outlook/controller/datecontroller.dart';
import 'package:intl/intl.dart';
import '../components/booking_details.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../controller/datepickercontroller.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


class BookingScreen extends StatefulWidget {
  final data;
  final docid;
  BookingScreen({required this.data, required this.docid});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

bool flag = false;
DateTime? to;
DateTime? from;
List<String> finaltime = [];

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finaltime = [];
    // PaymentService.init();
    String month =
        '${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}';
    String day =
        '${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}';
    DateTime to1 = DateFormat.jm().parse(widget.data['to']);
    DateTime from1 = DateFormat.jm().parse(widget.data['from']);
    final to2 = DateFormat("HH:mm").format(to1);
    final from2 = DateFormat("HH:mm").format(from1);
    to = DateTime.parse('${DateTime.now().year}-$month-$day $to2:04Z');
    from = DateTime.parse('${DateTime.now().year}-$month-$day $from2:04Z');
    DateTime time = from!;
    finaltime.add(widget.data['from']);
    while (time.isBefore(to!)) {
      time = time.add(Duration(hours: 1, minutes: 30));
      print(time);
      DateTime tempDate =
          DateFormat("hh:mm").parse('${time.hour}:${time.minute}');
      var dateFormat = DateFormat("h:mm a");
      String datee = dateFormat.format(tempDate);
      finaltime.add(datee);
    }
  }
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment() async {
    try {

      paymentIntentData =
      await Get.put(ButtonController()).createPaymentIntent('50', 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      if(Platform.isAndroid || Platform.isIOS){
        if (flag == false) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please select available day')));
        }
        // else {
        //
        //   await Stripe.instance.initPaymentSheet(
        //       paymentSheetParameters: SetupPaymentSheetParameters(
        //           paymentIntentClientSecret: paymentIntentData!['client_secret'],
        //           style: ThemeMode.light,
        //           merchantDisplayName: 'Sagheer Ahmed')).then((value){
        //
        //   });
        //
        //   FirebaseFirestore.instance
        //       .collection("appointments")
        //       .doc()
        //       .set({
        //     "docname": widget.data['name'],
        //     "docid": widget.docid,
        //     "patientid": FirebaseAuth.instance.currentUser!.uid,
        //     "time": selectedTime!,
        //     "date": date,
        //     "status": 'pending'
        //   }).then((_) {
        //     Navigator.pop(context);
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //         content:
        //         Text('Appointment Booked Successfully!')));
        //   });
        // }
        else{
          await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntentData!['client_secret'],
                  style: ThemeMode.light,
                  merchantDisplayName: 'Sagheer Ahmed')).then((value){
          });
          displayPaymentSheet();
        }

      }
      else{

        print("web");
      }




      ///now finally display payment sheeet

    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {

    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
            confirmPayment: true,
          )).then((newValue) async {


        print('payment intent'+paymentIntentData!['id'].toString());
        print('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());

        await FirebaseFirestore.instance
            .collection("appointments")
            .doc()
            .set({
          "docname": widget.data['name'],
          "docid": widget.docid,
          "patientid": FirebaseAuth.instance.currentUser!.uid,
          "time": selectedTime,
          "date": date,
          "status": 'pending'
        }).then((_) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
              Text('Appointment Booked Successfully!')));
        });
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("paid successfully"),backgroundColor: Colors.black12,));

        paymentIntentData = null;

      }).onError((error, stackTrace){
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }
  String? selectedTime;
  String date = "";
  var schedule;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flag =false;
  }
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    return Scaffold(
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
          "Select Appointment Date",
          style: TextStyle(
            color: Color.fromRGBO(33, 45, 82, 1),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .where(
                'status',
                isEqualTo: 'pending',
              )
              .snapshots(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(widget.data['days'].replaceAll(',', ' ')),
                    Container(
                      height: 350.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: GetX<DatePickerController>(
                          init: DatePickerController(),
                          builder: (_) {
                            return SfDateRangePicker(
                              // monthViewSettings:
                              selectionColor: (_.booking().color),
                              enablePastDates: false,
                              minDate: DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day + 1),
                              headerStyle: DateRangePickerHeaderStyle(
                                  backgroundColor: kPrimaryColor,
                                  textAlign: TextAlign.center,
                                  textStyle: TextStyle(color: Colors.white)),
                              onSelectionChanged: (value) {
                                String day = widget.data['days'];
                                DateFormat formatter =
                                    DateFormat.yMMMMEEEEd('en_US');
                                setState(() {
                                  date = formatter.format(value.value);
                                  for (var i = 0;
                                      i < snapshot.data!.docs.length;
                                      i++) {
                                    if (snapshot.data!.docs[i]['date'] ==
                                        date) {
                                      finaltime.removeWhere((element) =>
                                          element ==
                                          snapshot.data!.docs[i]['time']);
                                    }
                                    if (finaltime.contains(
                                        snapshot.data!.docs[i]['time'])) {
                                      continue;
                                    } else if (date !=
                                        snapshot.data!.docs[i]['date']) {
                                      finaltime
                                          .add(snapshot.data!.docs[i]['time']);
                                    }
                                  }
                                });
                                for (var i = 0;
                                    i < day.split(',').length;
                                    i++) {
                                  if (day
                                      .split(',')[i]
                                      .contains(date.split(',')[0])) {
                                    print('found');
                                    Get.find<DatePickerController>()
                                        .updateColor(kPrimaryColor);
                                    setState(() {
                                      flag = true;
                                    });
                                    break;
                                  } else {
                                    Get.find<DatePickerController>()
                                        .updateColor(Colors.red);
                                    flag = false;
                                  }
                                }

                                Get.find<DateController>().updateBooking(date);
                              },
                            );
                          }),
                    ),
                    GetX<DateController>(
                      init: DateController(),
                      builder: (_) {
                        return BookingDetails(_.booking().date);
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Appointment Time:  ',
                          style: TextStyle(fontSize: 16, color: kTextColor),
                        ),
                        DropdownButton<String>(
                            hint: selectedTime == null
                                ? Text(finaltime[0])
                                : Text(
                                    selectedTime!,
                                    style: TextStyle(
                                      color: kTextColor,
                                    ),
                                  ),
                            iconSize: 30.0,
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 16),
                            items: finaltime.map(
                              (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  selectedTime = val!;
                                },
                              );
                            }),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        await makePayment();
                        // if (flag == false) {
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //       content: Text('Please select available day')));
                        // }
                        // else {
                        //   FirebaseFirestore.instance
                        //       .collection("appointments")
                        //       .doc()
                        //       .set({
                        //     "docname": widget.data['name'],
                        //     "docid": widget.docid,
                        //     "patientid": FirebaseAuth.instance.currentUser!.uid,
                        //     "time": selectedTime!,
                        //     "date": date,
                        //     "status": 'pending'
                        //   }).then((_) {
                        //     Navigator.pop(context);
                        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //         content:
                        //         Text('Appointment Booked Successfully!')));
                        //   });
                        // }

                      },
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(169, 176, 185, 0.42),
                              spreadRadius: 0,
                              blurRadius: 8.0,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Confirm Booking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  bool dateflag = false;
}
