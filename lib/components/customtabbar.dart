import 'package:flutter/material.dart';
import 'package:outlook/constants.dart';
import 'package:outlook/responsive.dart';

class CustomTabBar extends StatelessWidget {
  CustomTabBar({required this.controller, required this.tabs});

  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabBarScaling = screenWidth > 1400
        ? 0.2
        : screenWidth > 1100
            ? 0.3
            : 0.4;
    return Container(
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width * 0.5
          : MediaQuery.of(context).size.width,
      child: Theme(
        data: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: controller,
          indicatorColor: Color(0xff21a179),
          tabs: tabs,
        ),
      ),
      // ),
    );
  }
}
