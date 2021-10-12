import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowSnackBar {
  Future<dynamic>? showSnackBar(String title,
      {SnackBarAction? action, Duration? duration, bool noAction = false}) {
    return Get.showSnackbar(
      GetBar(
        duration: duration ?? const Duration(seconds: 2),
        backgroundColor: Colors.grey[900]!,
        messageText: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        mainButton: noAction
            ? null
            : action ??
                SnackBarAction(
                  textColor: currentTheme.currentColor(),
                  label: 'Ok',
                  onPressed: () {},
                ),
      ),
    );
  }
}
