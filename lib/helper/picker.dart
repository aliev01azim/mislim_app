import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Picker {
  Future<String> selectFolder(BuildContext context, String message) async {
    final String? temp = await FilePicker.platform.getDirectoryPath();
    return (temp == '/' || temp == null) ? '' : temp;
  }
}
