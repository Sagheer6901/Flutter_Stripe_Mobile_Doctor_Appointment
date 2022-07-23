import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:outlook/constants.dart';
import 'package:outlook/responsive.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp = new RegExp(p);
final isloading = false;
TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController message = TextEditingController();

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height * 0.95,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image(
                    image: AssetImage('assets/images/aboutus.jpg'),
                    height: Responsive.isMobile(context)
                        ? height * 0.4
                        : height * 0.65,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: Responsive.isMobile(context)
                              ? height * 0.2
                              : height * 0.26),
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                            fontSize: Responsive.isMobile(context) ? 35 : 50,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
                height: Responsive.isMobile(context)
                    ? height * 0.85
                    : height * 0.95,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.red, width: 5))),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Container(
                      width: Responsive.isMobile(context)
                          ? MediaQuery.of(context).size.width * 0.7
                          : MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter your Name',
                        ),
                      ),
                    ),
                    Container(
                      width: Responsive.isMobile(context)
                          ? MediaQuery.of(context).size.width * 0.7
                          : MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        controller: phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter your Phone number',
                        ),
                      ),
                    ),
                    Container(
                      width: Responsive.isMobile(context)
                          ? MediaQuery.of(context).size.width * 0.7
                          : MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter your email',
                        ),
                      ),
                    ),
                    Container(
                      width: Responsive.isMobile(context)
                          ? MediaQuery.of(context).size.width * 0.7
                          : MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        controller: message,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Type your message here...',
                          hintMaxLines: 5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: Container(
                        height: 50,
                        width: 300,
                        child: isloading == true
                            ? Center(child: CircularProgressIndicator())
                            : RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                color: kPrimaryColor,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  vaildation().then((_) async {
                                    await sendEmail(
                                            '${name.text} Phone number: ${phone.text}',
                                            email.text,
                                            message.text)
                                        .then((value) {
                                      if (value == 'OK') {
                                        email.clear();
                                        phone.clear();
                                        message.clear();
                                        name.clear();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Response submitted successfully')));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Oops! Error while submitting Response')));
                                      }
                                    });
                                  });
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                width: double.infinity,
                color: kTitleTextColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        Text('  info@medavex.org',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? errorMessage;

  Future vaildation() async {
    if (name.text.isEmpty &&
        phone.text.isEmpty &&
        email.text.isEmpty &&
        message.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Fleids Are Empty"),
        ),
      );
    } else if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Not Vaild"),
        ),
      );
    } else if (message.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please type message"),
        ),
      );
    }
  }
}

Future sendEmail(String name, String email, String message) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_avbmemx';
  const templateId = 'template_pfns2j9';
  const userId = 'Y5VZYOGtQrThpBG76';
  final response = await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json'
      }, //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'from_name': name,
          'from_email': email,
          'message': message
        }
      }));
  return response.body;
}
