// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'web_view.dart';

// void main() {
//   runApp(const MaterialApp(home: _WebViewExample()));
// }

class WebViewExample extends StatefulWidget {
  String? selectedTime;
  var date,instanceUser,name,docid;
  WebViewExample( {Key? key,this.selectedTime, this.date, this.instanceUser,this.name,this.docid}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Flutter WebView example'),
      //   actions: <Widget>[
      //     _SampleMenu(_controller.future),
      //   ],
      // ),
      body: WebView(
        initialUrl: 'https://mobicell.net/stripe/checkout.html',
        onWebViewCreated: (WebViewController controller) {
          _controller.complete(controller);
        },
        onPageStarted: (String url) async {
          print('Page started loading: $url');
          if(url.contains("success")) {
            await FirebaseFirestore.instance
                .collection("appointments")
                .doc()
                .set({
              "docname": widget.name,
              "docid": widget.docid,
              "patientid": widget.instanceUser,
              "time": widget.selectedTime,
              "date": widget.date,
              "status": 'pending'
            }).then((_) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                  Text('Appointment Booked Successfully!')));
            });
            //orderPlaceApi(paymentIntentData!['id'].toString())
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("paid successfully"),backgroundColor: Colors.black12,));

          }
          else{
            Navigator.pop(context);
          }
        },
    onPageFinished: (String url)  async {
      print('Page finished loading: $url');
      if(url.contains("success")) {
        await FirebaseFirestore.instance
            .collection("appointments")
            .doc()
            .set({
          "docname": widget.name,
          "docid": widget.docid,
          "patientid": widget.instanceUser,
          "time": widget.selectedTime,
          "date": widget.date,
          "status": 'pending'
        }).then((_) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
              Text('Appointment Booked Successfully!')));
        });
      //orderPlaceApi(paymentIntentData!['id'].toString())
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("paid successfully"),backgroundColor: Colors.black12,));

      }
      else{
        Navigator.pop(context);
      }
    }
    ),
    );
  }
}

enum _MenuOptions {
  doPostRequest,
}

class _SampleMenu extends StatelessWidget {
  const _SampleMenu(this.controller);

  final Future<WebViewController> controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<_MenuOptions>(
          onSelected: (_MenuOptions value) {
            switch (value) {
              case _MenuOptions.doPostRequest:
                _onDoPostRequest(controller.data!, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<_MenuOptions>>[
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.doPostRequest,
              child: Text('Post Request'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDoPostRequest(
      WebViewController controller, BuildContext context) async {
    final WebViewRequest request = WebViewRequest(
      uri: Uri.parse('https://httpbin.org/post'),
      method: WebViewRequestMethod.post,
      headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
      body: Uint8List.fromList('Test Body'.codeUnits),
    );
    await controller.loadRequest(request);
  }
}