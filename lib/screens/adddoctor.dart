import 'dart:convert';
import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outlook/core/database.dart';
import 'package:outlook/screens/main/main_screen.dart';

import '../components/customtextfield.dart';
import '../components/pickimage.dart';
import '../constants.dart';

class AddDoctor extends StatefulWidget {
  const AddDoctor({Key? key}) : super(key: key);

  @override
  State<AddDoctor> createState() => _AddDoctorState();
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

class _AddDoctorState extends State<AddDoctor> {
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
                    'Doctor Registeration',
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
                  hintText: 'Name',
                  label: 'name',
                  controller: name,
                  data: Icons.list,
                  isObsecure: false,
                  flag: true,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Training',
                  label: 'Training',
                  controller: category,
                  data: Icons.align_vertical_bottom_sharp,
                  isObsecure: false,
                  flag: true,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Experience',
                  label: 'experience',
                  controller: experience,
                  data: Icons.input,
                  isObsecure: false,
                  flag: true,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Short info',
                  label: 'Short Info',
                  controller: shortinfo,
                  data: Icons.edit,
                  isObsecure: false,
                  flag: true,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Description',
                  label: 'Description',
                  controller: desc,
                  data: Icons.description,
                  isObsecure: false,
                  flag: true,
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
                        label: Text('contact'),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: kTitleTextColor,
                        ),
                        focusColor: kPrimaryColor,
                        hintText: 'Contact',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z]")),
                      ]),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
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
                        // <== Callback to handle the selected days
                        // print(values);
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
                        'Add Doctor',
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
                        vaildation();
                        database.RegisterDoc(
                                localmage,
                                name.text,
                                category.text,
                                experience.text,
                                contact.text,
                                day,
                                fromTime!,
                                toTime!,
                                _selectedLocation!,
                                shortinfo.text,
                                desc.text)
                            .then((_) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => MainScreen(
                                        role: 'admin',
                                      )))
                              .then((_) {
                            Fluttertoast.showToast(
                                msg:
                                    "Registered Successfully now you can login",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          });
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

  String? fromTime;
  String? toTime;
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

  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static RegExp regExp = new RegExp(p);

  void vaildation() {
    if (name.text.isEmpty &&
        category.text.isEmpty &&
        experience.text.isEmpty &&
        shortinfo.text.isEmpty &&
        contact.text.isEmpty &&
        desc.text.isEmpty &&
        localmage == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Fleids Are Empty"),
        ),
      );
    } else if (name.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Is Empty"),
        ),
      );
    } else if (category.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Training Is Empty"),
        ),
      );
    } else if (experience.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Experience Is Empty"),
        ),
      );
    } else if (shortinfo.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Short info Is Empty"),
        ),
      );
    } else if (contact.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("contact Is Empty"),
        ),
      );
    } else if (desc.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Description Is Empty"),
        ),
      );
    } else if (localmage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Select an image"),
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: "Registeration Successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
