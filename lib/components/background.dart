import 'package:flutter/material.dart';
import 'package:outlook/components/tabcontrollerhandler.dart';
import 'package:outlook/screens/Welcome/aboutus.dart';
import 'package:outlook/screens/Welcome/welcome_screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'contentview.dart';
import 'customtab.dart';
import 'customtabbar.dart';

class Background extends StatefulWidget {
  final Widget? child;
  Background({
    Key? key,
    this.child,
    this.topImage = "assets/images/main_top.png",
    this.bottomImage = "assets/images/login_bottom.png",
  }) : super(key: key);

  final String topImage, bottomImage;

  @override
  State<Background> createState() => _BackgroundState();
}

TabController? tabController;
ItemScrollController? itemScrollController;

class _BackgroundState extends State<Background>
// with SingleTickerProviderStateMixin
{
  // List<ContentView> contentViews = [
  //   ContentView(
  //     tab: CustomTab(title: 'Home'),
  //     content: WelcomeScreen(),
  //   ),
  //   ContentView(
  //     tab: CustomTab(title: 'About'),
  //     content: AboutUs(),
  //   ),
  //   ContentView(
  //     tab: CustomTab(title: 'Projects'),
  //     content: AboutUs(),
  //   )
  // ];

  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   tabController = TabController(vsync: this, length: contentViews.length);
  //   itemScrollController = ItemScrollController();
  // }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //   Container(
        //     height: screenHeight * 0.05,
        //     child: CustomTabBar(
        //         controller: tabController!,
        //         tabs: contentViews.map((e) => e.tab).toList()),
        //   ),
        //   Container(
        //   height: screenHeight * 0.8,
        //   child: TabControllerHandler(
        //     tabController: tabController!,
        //     child: TabBarView(
        //       controller: tabController,
        //       children: contentViews.map((e) => e.content).toList(),
        //     ),
        //   ),
        // ),

        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.95,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  widget.topImage,
                  width: 120,
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: Image.asset(bottomImage, width: 120),
              // ),
              SafeArea(child: widget.child!),
            ],
          ),
        ),
      ],
      // ),
    );
  }

//   Widget drawer() {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.5,
//       child: Drawer(
//         child: ListView(
//           children:
//               [Container(height: MediaQuery.of(context).size.height * 0.1)] +
//                   contentViews
//                       .map((e) => Container(
//                             child: ListTile(
//                               title: Text(
//                                 e.tab.title,
//                                 style: Theme.of(context).textTheme.button,
//                               ),
//                               onTap: () {
//                                 itemScrollController!.scrollTo(
//                                     index: contentViews.indexOf(e),
//                                     duration: Duration(milliseconds: 300));
//                               },
//                             ),
//                           ))
//                       .toList(),
//         ),
//       ),
//     );
//   }
}
