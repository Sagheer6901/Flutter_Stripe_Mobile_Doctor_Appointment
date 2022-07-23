import 'package:flutter/material.dart';
import 'package:outlook/cancelledappointments.dart';
import 'package:outlook/components/side_menu.dart';
import 'package:outlook/responsive.dart';
import 'package:outlook/screens/auth/signup.dart';
import 'package:outlook/upcomingappointments.dart';
import '../../components/user_side_menu.dart';

class AddAdminPage extends StatelessWidget {
  final role;
  AddAdminPage({required this.role});
  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: SignUp(
          role: role,
        ),
        tablet: Row(
          children: [
            Expanded(
              flex: 1,
              child: role == 'admin' ? SideMenu() : UserSideMenu(),
            ),
            Expanded(
              flex: 4,
              child: SignUp(
                role: role,
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              // flex: _size.width > 1340 ? 2 : 4,
              flex: 1,
              child: role == 'admin' ? SideMenu() : UserSideMenu(),
            ),
            Expanded(
              flex: 4,
              // flex: _size.width > 1340 ? 3 : 5,
              child: SignUp(
                role: role,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
