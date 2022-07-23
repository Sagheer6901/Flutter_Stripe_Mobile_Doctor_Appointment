import 'package:get/get.dart';
import 'package:outlook/models/booking.dart';

class DateController extends GetxController {
  final booking = Booking(date: "").obs;
  updateBooking(String date) {
    booking.update((val) {
      val!.date = date;
    });
  }
}
