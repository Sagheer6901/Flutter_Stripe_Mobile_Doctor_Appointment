import 'package:flutter/material.dart';
import 'package:outlook/constants.dart';
import 'package:outlook/responsive.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

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
                        'About Us',
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
                height:
                    Responsive.isMobile(context) ? height * 0.55 : height * 0.6,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        child: Text(
                          'Who are we?',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.red, width: 5))),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: Responsive.isDesktop(context)
                              ? MediaQuery.of(context).size.width * 0.015
                              : Responsive.isMobile(context)
                                  ? 10
                                  : MediaQuery.of(context).size.width * 0.01,
                          right: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'IllMobiles’s mission is to bring exceptional care directly to young people, right where they are.',
                              style: TextStyle(
                                  fontSize: Responsive.isDesktop(context)
                                      ? 24
                                      : Responsive.isMobile(context)
                                          ? 16
                                          : 18),
                              textAlign: TextAlign.left),
                          Text(
                              'Our expertly trained providers help young people heal in any setting:  home, airport, boat, or car.',
                              style: TextStyle(
                                  fontSize: Responsive.isDesktop(context)
                                      ? 24
                                      : Responsive.isMobile(context)
                                          ? 16
                                          : 20),
                              textAlign: TextAlign.left),
                          Text(
                              'The convenience and safety of having care come to you makes the care experience ideal.',
                              style: TextStyle(
                                  fontSize: Responsive.isDesktop(context)
                                      ? 24
                                      : Responsive.isMobile(context)
                                          ? 16
                                          : 20),
                              textAlign: TextAlign.left),
                          Text(
                              'We serve patients from West Palm Beach to Miami, including Delray Beach, Boca Raton, Ft. Lauderdale,',
                              style: TextStyle(
                                  fontSize: Responsive.isDesktop(context)
                                      ? 24
                                      : Responsive.isMobile(context)
                                          ? 16
                                          : 20),
                              textAlign: TextAlign.left),
                          Text(' and Hollywood.',
                              style: TextStyle(
                                  fontSize: Responsive.isDesktop(context)
                                      ? 24
                                      : Responsive.isMobile(context)
                                          ? 16
                                          : 20),
                              textAlign: TextAlign.left),
                        ],
                      ),
                    )
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
}
