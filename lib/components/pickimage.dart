import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<String> pickImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? _imagePicker =
      await _picker.pickImage(source: ImageSource.gallery);
  if (_imagePicker != null) {
    Uint8List bytes = await _imagePicker.readAsBytes();
    String encode = base64Encode(bytes);
    return encode;
  } else {
    if (kDebugMode) {
      print('Pick Image First');
    }
    return 'Error';
  }
}
