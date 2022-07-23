import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:outlook/constants.dart';
import 'package:outlook/responsive.dart';

class Providers extends StatelessWidget {
  const Providers({Key? key}) : super(key: key);

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
                        'Providers',
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
                    Responsive.isMobile(context) ? height * 0.55 : height * 0.5,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        child: Text(
                          'Our Providers',
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
                              ? MediaQuery.of(context).size.width * 0.18
                              : 20
                          // right: Responsive.isMobile(context) ? 10 : 100
                          ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Auren Weinberg, MD, MBA is the founder and owner of IMK4K.',
                            style: TextStyle(
                                fontSize: Responsive.isDesktop(context)
                                    ? 24
                                    : Responsive.isMobile(context)
                                        ? 16
                                        : 20),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                              'Training:  Children’s Hospital of Philadelphia, U. of Rochester School of Medicine',
                              style: TextStyle(
                                  fontSize: Responsive.isDesktop(context)
                                      ? 24
                                      : Responsive.isMobile(context)
                                          ? 16
                                          : 20),
                              textAlign: TextAlign.left),
                          Text('Healthcare experience:  20+ years',
                              style: TextStyle(
                                  fontSize: Responsive.isDesktop(context)
                                      ? 24
                                      : Responsive.isMobile(context)
                                          ? 16
                                          : 20),
                              textAlign: TextAlign.left),
                          Text('English proficiency:  Excellent',
                              style: TextStyle(
                                  fontSize: Responsive.isDesktop(context)
                                      ? 24
                                      : Responsive.isMobile(context)
                                          ? 16
                                          : 20),
                              textAlign: TextAlign.left),
                          Text(
                              'Spanish proficiency:  Beginner, translator will be provided if required',
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
