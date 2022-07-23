import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outlook/responsive.dart';
import 'package:outlook/screens/Welcome/aboutus.dart';
import 'package:outlook/screens/Welcome/contactus.dart';
import 'package:outlook/screens/Welcome/providers.dart';
import 'package:outlook/screens/Welcome/welcome_screen.dart';
import 'package:outlook/screens/doc_profile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../components/contentview.dart';
import '../../components/customtab.dart';
import '../../components/customtabbar.dart';
import '../../components/tabcontrollerhandler.dart';
import '../../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  ItemScrollController? itemScrollController;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  double? screenHeight;
  double? screenWidth;
  double? topPadding;
  double? bottomPadding;
  double? sidePadding;

  List<ContentView> contentViews = [
    ContentView(
      tab: CustomTab(title: 'Home'),
      content: WelcomeScreen(),
    ),
    ContentView(
      tab: CustomTab(title: 'About'),
      content: AboutUs(),
    ),
    ContentView(
      tab: CustomTab(title: 'Providers'),
      content: Providers(),
    ),
    ContentView(
      tab: CustomTab(title: 'Cost'),
      content: Providers(),
    ),
    ContentView(
      tab: CustomTab(title: 'Contact Us'),
      content: ContactUs(),
    )
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    itemScrollController = ItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    topPadding = screenHeight! * 0.05;
    bottomPadding = screenHeight! * 0.03;
    sidePadding = screenWidth! * 0.05;

    print('Width: $screenWidth');
    print('Height: $screenHeight');
    return Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        endDrawer: drawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// Tab Bar
              Container(
                margin:
                    EdgeInsets.only(top: Responsive.isMobile(context) ? 20 : 0),
                height: screenHeight! * 0.05,
                child: CustomTabBar(controller: tabController!, tabs: [
                  Tab(
                      child: FittedBox(
                    child: Text('Home',
                        style: TextStyle(fontSize: 13, color: kTitleTextColor)),
                  )),
                  Tab(
                      child: FittedBox(
                    child: Text('About Us',
                        style: TextStyle(fontSize: 13, color: kTitleTextColor)),
                  )),
                  Tab(child: FittedBox(child: dropDown())),
                  Tab(
                      child: FittedBox(
                    child: Text('Cost',
                        style: TextStyle(fontSize: 13, color: kTitleTextColor)),
                  )),
                  Tab(
                      child: FittedBox(
                    child: Text('Contact Us',
                        style: TextStyle(fontSize: 13, color: kTitleTextColor)),
                  )),
                ]),
              ),

              /// Tab Bar View
              Container(
                height: screenHeight! * 0.95,
                child: TabControllerHandler(
                  tabController: tabController!,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      WelcomeScreen(),
                      AboutUs(),
                      Providers(),
                      Providers(),
                      ContactUs()
                    ],
                  ),
                ),
              ),

              /// Bottom Bar
              // BottomBar()
            ],
          ),
        ));
  }

  Widget drawer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
          child: ListView(
              children: [
                    Container(height: MediaQuery.of(context).size.height * 0.1)
                  ] +
                  // contentViews
                  //     .map((e) =>
                  [
                    Container(
                      child: ListTile(
                        title: Text(
                          'Home',
                          style: Theme.of(context).textTheme.button,
                        ),
                        onTap: () {
                          itemScrollController!.scrollTo(
                              index: 0, duration: Duration(milliseconds: 300));
                        },
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(
                          'About Us',
                          style: Theme.of(context).textTheme.button,
                        ),
                        onTap: () {
                          itemScrollController!.scrollTo(
                              index: 1, duration: Duration(milliseconds: 300));
                        },
                      ),
                    ),
                    Container(
                      child: dropDown(),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(
                          'Cost',
                          style: Theme.of(context).textTheme.button,
                        ),
                        onTap: () {
                          itemScrollController!.scrollTo(
                              index: 3, duration: Duration(milliseconds: 300));
                        },
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(
                          'Contact Us',
                          style: Theme.of(context).textTheme.button,
                        ),
                        onTap: () {
                          itemScrollController!.scrollTo(
                              index: 4, duration: Duration(milliseconds: 300));
                        },
                      ),
                    ),
                  ])
          // .toList(),
          ),
    );
  }

  final Stream<QuerySnapshot> doctorStream =
      FirebaseFirestore.instance.collection('doctor').snapshots();
  String? selectedProviders;
  List<String> names = [];
  List<String> docid = [];
  int? index;
  Widget dropDown() {
    return StreamBuilder<QuerySnapshot>(
        stream: doctorStream,
        builder: (context, snapshot) {
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            if (names.length == 0) {
              names.add(snapshot.data!.docs[i]['name']);
              docid.add(snapshot.data!.docs[i].id);
            }
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Oops! An error has occured'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.size == 0) {
            return Center(
                child: Text('No available Doctors or No internet connection'));
          }
          return names.length == 0
              ? Text('waiting for data')
              : DropdownButton<String>(
                  value: index == null ? null : names[index!],
                  hint: selectedProviders == null
                      ? Text('Providers',
                          style:
                              TextStyle(fontSize: 13, color: kTitleTextColor))
                      : Text(
                          selectedProviders!,
                          style: TextStyle(
                            color: kTextColor,
                          ),
                        ),
                  style: TextStyle(color: kTitleTextColor, fontSize: 13),
                  items: names.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        selectedProviders = val!;
                        index = names.indexOf(val);
                        print(docid[index!]);
                      },
                    );
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DoctorProfile(
                              docid: docid[index!],
                              role: null,
                            )));
                  });
        });
  }
}
