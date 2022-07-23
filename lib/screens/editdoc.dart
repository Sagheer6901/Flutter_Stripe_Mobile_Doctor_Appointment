import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outlook/core/database.dart';
import 'package:outlook/screens/main/main_screen.dart';

import '../components/customtextfield.dart';
import '../components/pickimage.dart';
import '../constants.dart';

class EditDoctor extends StatefulWidget {
  var docdata;
  final docid;
  EditDoctor({Key? key, required this.docdata, required this.docid})
      : super(key: key);

  @override
  State<EditDoctor> createState() => _AddDoctorState();
}

TextEditingController name = TextEditingController();
TextEditingController category = TextEditingController();
TextEditingController experience = TextEditingController();
TextEditingController contact = TextEditingController();
TextEditingController shortinfo = TextEditingController();
TextEditingController desc = TextEditingController();

Database database = new Database();
List<String> data = ['English', 'Spanish', 'Both']; // Option 2
List<DayInWeek> _days = [
  DayInWeek(
    "Sun",
  ),
  DayInWeek(
    "Mon",
  ),
  DayInWeek(
      "Tue",
      isSelected: true
  ),
  DayInWeek(
    "Wed",
  ),
  DayInWeek(
    "Thu",
  ),
  DayInWeek(
    "Fri",
  ),
  DayInWeek(
    "Sat",
  ),
];
String? _selectedLocation;
String? fromTime;
String? toTime;

class _AddDoctorState extends State<EditDoctor> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fromTime = widget.docdata['from'];
      toTime = widget.docdata['to'];
      localmage = widget.docdata['image'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 1100,
            width: 400,
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Update Doctor',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: chooseImage,
                  child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFFEDBD0),
                      backgroundImage: localmage == null
                          ? null
                          : MemoryImage(base64Decode(localmage)),
                      child: localmage == null
                          ? Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.black,
                            )
                          : null),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: widget.docdata['name'],
                  label: 'name',
                  controller: name,
                  data: Icons.list,
                  isObsecure: false,
                  flag: false,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: widget.docdata['category'],
                  label: 'Training',
                  controller: category,
                  data: Icons.align_vertical_bottom_sharp,
                  isObsecure: false,
                  flag: false,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: widget.docdata['experience'],
                  label: 'experience',
                  controller: experience,
                  data: Icons.input,
                  isObsecure: false,
                  flag: false,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: widget.docdata['shortinfo'],
                  label: 'Short Info',
                  controller: shortinfo,
                  data: Icons.edit,
                  isObsecure: false,
                  flag: false,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: widget.docdata['desc'],
                  label: 'Description',
                  controller: desc,
                  data: Icons.description,
                  isObsecure: false,
                  flag: false,
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(10.0),
                  child: TextFormField(
                      maxLength: 11,
                      controller: contact,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // label: Text('contact'),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: kTitleTextColor,
                        ),
                        focusColor: kPrimaryColor,
                        hintText: widget.docdata['contact'],
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z]")),
                      ]),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectWeekDays(
                      days: _days,
                      daysFillColor: kPrimaryColor,
                      selectedDayTextColor: Colors.white,
                      unSelectedDayTextColor: kTitleTextColor,
                      boxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          colors: [Colors.transparent, Colors.transparent],
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      onSelect: (values) {
                        days = values;

                        print(days);
                      },
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: FromTime,
                              child: const Text('Available from')),
                          Text(
                            fromTime != null ? fromTime! : '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: ToTime,
                              child: const Text('Available To')),
                          Text(
                            toTime != null ? toTime! : '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Proficiency:\t',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                        hint: _selectedLocation == null
                            ? Text(data[0])
                            : Text(
                                _selectedLocation!,
                                style: TextStyle(
                                  color: kTextColor,
                                ),
                              ),
                        iconSize: 30.0,
                        style: TextStyle(color: kPrimaryColor, fontSize: 16),
                        items: data.map(
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
                              _selectedLocation = val!;
                            },
                          );
                        }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Container(
                    height: 50,
                    width: 300,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      color: kPrimaryColor,
                      child: Text(
                        'Update Doctor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        String day = '';
                        for (var i = 0; i < days.length; i++) {
                          day = '$day,${days[i]}';
                        }
                        EditDoc(
                                localmage,
                                name.text.isEmpty
                                    ? widget.docdata['name']
                                    : name.text,
                                category.text.isEmpty
                                    ? widget.docdata['category']
                                    : category.text,
                                experience.text.isEmpty
                                    ? widget.docdata['experience']
                                    : experience.text,
                                contact.text.isEmpty
                                    ? widget.docdata['contact']
                                    : contact.text,
                                day,
                                fromTime!,
                                toTime!,
                                _selectedLocation!,
                                shortinfo.text.isEmpty
                                    ? widget.docdata['shortinfo']
                                    : shortinfo.text,
                                desc.text.isEmpty
                                    ? widget.docdata['desc']
                                    : desc.text,
                                widget.docid)
                            .then((_) {
                          Fluttertoast.showToast(
                              msg: "Doctor updated Successfully",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: kPrimaryColor,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MainScreen(
                                    role: 'admin',
                                  )));
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List days = [];
  TimeOfDay selectedTime = TimeOfDay.now();

  var localmage;

  void chooseImage() async {
    localmage = await pickImage();
    setState(() {});
    if (localmage != null)
      image:
      localmage;
  }

  Future<void> FromTime() async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 12-Hour format
                  alwaysUse24HourFormat: false),
              // If you want 24-Hour format, just change alwaysUse24HourFormat to true
              child: child!);
        });
    if (result != null) {
      setState(() {
        fromTime = result.format(context);
      });
    }
  }

  Future<void> ToTime() async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 12-Hour format
                  alwaysUse24HourFormat: false),
              // If you want 24-Hour format, just change alwaysUse24HourFormat to true
              child: child!);
        });
    if (result != null) {
      setState(() {
        toTime = result.format(context);
      });
    }
  }
}

Future EditDoc(
    String image,
    String name,
    String category,
    String experience,
    String cell,
    String days,
    String from,
    String to,
    String proficiency,
    String shortinfo,
    String desc,
    String docid) async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  await firebaseFirestore.collection('doctor').doc(docid).update({
    'image': image,
    'name': name,
    'category': category,
    'experience': experience,
    'contact': cell,
    'days': days,
    'from': from,
    'to': to,
    'Proficiency': proficiency,
    'shortinfo': shortinfo,
    'desc': desc
  });
}
