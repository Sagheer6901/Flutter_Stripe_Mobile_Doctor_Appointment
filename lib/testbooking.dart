import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:outlook/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'components/booking_details.dart';
import 'controller/datecontroller.dart';
import 'controller/datepickercontroller.dart';

class BookingTest extends StatefulWidget {
  final data;
  final docid;
  const BookingTest({Key? key, required this.data, required this.docid})
      : super(key: key);

  @override
  State<BookingTest> createState() => _BookingTestState();
}

String date = "";
bool flag = false;

class _BookingTestState extends State<BookingTest> {
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
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
                    minDate: DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day + 1),
                    headerStyle: DateRangePickerHeaderStyle(
                        backgroundColor: kPrimaryColor,
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(color: Colors.white)),
                    onSelectionChanged: (value) {
                      String day = widget.data['days'];
                      DateFormat formatter = DateFormat.yMMMMEEEEd('en_US');
                      setState(() {
                        date = formatter.format(value.value);
                      });
                      for (var i = 0; i < day.split(',').length; i++) {
                        if (day.split(',')[i].contains(date.split(',')[0])) {
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
        ],
      ),
    );
  }
}
