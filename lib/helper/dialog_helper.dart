import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  //show error dialog
  static void showErroDialog(
      {String title = 'Ошибка',
      String? description = 'Что-то пошло не так...'}) {
    Get.dialog(
      Dialog(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: Get.textTheme.headline4,
              ),
              Text(
                description ?? '',
                textAlign: TextAlign.center,
                style: Get.textTheme.headline6,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    if (Get.isDialogOpen!) Get.back();
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(
                        fontSize: 20, color: currentTheme.currentColor()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
