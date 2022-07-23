import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:outlook/models/Email.dart';
import 'package:outlook/screens/doc_profile.dart';
import 'package:outlook/screens/doctor_details.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import '../../../extensions.dart';

class EmailCard extends StatefulWidget {
  const EmailCard(
      {Key? key,
      this.isActive = false,
      required this.email,
      required this.press,
      required this.docid,
      required this.role})
      : super(key: key);

  final bool isActive;
  final Email email;
  final String docid;
  final role;
  final VoidCallback press;

  @override
  State<EmailCard> createState() => _EmailCardState();
}

bool btnflag = false;

class _EmailCardState extends State<EmailCard> {
  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DoctorProfile(
                  docid: widget.docid,
                  role: widget.role,
                )));
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: kBgDarkColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  fit: BoxFit.scaleDown,
                                  image: (MemoryImage(
                                      base64Decode(widget.email.image))))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kDefaultPadding / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.email.name}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kTextColor,
                      ),
                    ),
                    Text(
                      "(experience: ${widget.email.experience})",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: kTextColor,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: kDefaultPadding / 2),
                Text(
                  "${widget.email.shortinfo}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kTextColor,
                  ),
                ),
                SizedBox(height: kDefaultPadding / 2),
                Text(
                  'Available days: ${widget.email.body.replaceAll(',', ' ')}',
                  style: TextStyle(fontSize: 14, color: kTextColor),
                ),
              ],
            ),
          ).addNeumorphism(
            blurRadius: 15,
            borderRadius: 15,
            offset: Offset(5, 5),
            topShadowColor: Colors.white60,
            bottomShadowColor: Color(0xFF234395).withOpacity(0.15),
          ),
          if (!widget.email.isChecked)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kBadgeColor,
                ),
              ).addNeumorphism(
                blurRadius: 4,
                borderRadius: 8,
                offset: Offset(2, 2),
              ),
            ),
        ],
      ),
    );
  }
}
