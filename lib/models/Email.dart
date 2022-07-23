import 'package:flutter/material.dart';

class Email {
  final String image, name, subject, time;
  final bool isAttachmentAvailable, isChecked;
  final Color tagColor;
  final String body;
  final String shortinfo;
  final String experience;

  Email({
    required this.time,
    required this.experience,
    required this.shortinfo,
    required this.isChecked,
    required this.image,
    required this.name,
    required this.subject,
    required this.body,
    required this.isAttachmentAvailable,
    required this.tagColor,
  });
}
