import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:outlook/constants.dart';
import 'package:outlook/models/datepicker.dart';

class DatePickerController extends GetxController {
  final booking = DatePicker(color: kPrimaryColor).obs;
  updateColor(Color color) {
    booking.update((val) {
      val!.color = color;
    });
  }
}
