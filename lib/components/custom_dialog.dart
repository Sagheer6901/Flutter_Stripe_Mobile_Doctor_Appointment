import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomDialog extends StatelessWidget {

  final String title, subtitle,primaryActionText;
  final primaryAction;

  CustomDialog({
    required this.title,
    required this.subtitle,
    required this.primaryActionText,
    required this.primaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
      ),
      content: Text(subtitle),
      actions: [
        TextButton(
          child: Text(
            primaryActionText,

          ),
          onPressed: primaryAction,
        ),
      ],
    );
  }
}