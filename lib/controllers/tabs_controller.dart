import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';

class TabsController extends GetxController {
// for main tabs
  var selectedIndex = 0;
  void changePage(int value) {
    selectedIndex = value;
    update();
  }

  checkVersion(BuildContext context) async {
    final newVersion = NewVersion(
      androidId: "com.islamic_lectures",
      iOSId: "com.islamic_lectures",
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status!,
      dialogTitle: "Доступно обновление",
      dismissButtonText: "Пропустить",
      dialogText: "Пожалуйста,обновите Исламские Лекции с " +
          status.localVersion +
          " до " +
          status.storeVersion,
      dismissAction: () {
        SystemNavigator.pop();
      },
      updateButtonText: "Обновить",
    );

    print("DEVICE : " + status.localVersion);
    print("STORE : " + status.storeVersion);
  }

  // for library tabs
  var selectedIndex2 = 0;
  void changePage2(int value) {
    selectedIndex2 = value;
    update();
  }
}
