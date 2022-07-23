import 'package:flutter/material.dart';
import 'package:outlook/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;
  final String label;
  bool flag;

  CustomTextField(
      {Key? key,
      required this.controller,
      required this.data,
      required this.hintText,
      required this.label,
      required this.isObsecure,
      required this.flag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return flag == true
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: controller,
              obscureText: isObsecure,
              decoration: InputDecoration(
                // border: ,
                label: Text(label),
                prefixIcon: Icon(
                  data,
                  color: Color(0xFF30384D),
                ),
                focusColor: kPrimaryColor,
                hintText: hintText,
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: controller,
              obscureText: isObsecure,
              decoration: InputDecoration(
                // border: ,
                prefixIcon: Icon(
                  data,
                  color: Color(0xFF30384D),
                ),
                focusColor: kPrimaryColor,
                hintText: hintText,
              ),
            ),
          );
  }
}
