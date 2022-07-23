import 'package:flutter/material.dart';
import 'package:outlook/constants.dart';

class CustomTab extends StatelessWidget {
  final String title;
  CustomTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Text(this.title,
            style: TextStyle(fontSize: 13, color: kTitleTextColor)));
  }
}
