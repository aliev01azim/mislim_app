import 'package:aidar_zakaz/controllers/tabs_controller.dart';
import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/screens/home_screen.dart';
import 'package:aidar_zakaz/screens/search_screen.dart';
import 'package:aidar_zakaz/screens/setting_screen.dart';
import 'package:aidar_zakaz/widgets/bottom_bar.dart';
import 'package:aidar_zakaz/widgets/miniplayer.dart';
import 'package:aidar_zakaz/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'library/library.dart';

// ignore: must_be_immutable
class TabScreen extends StatelessWidget {
  TabScreen({Key? key}) : super(key: key);
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
    const LibraryPage(),
    SettingPage(),
  ];
  final controller = Get.put(TabsController());
  DateTime? backButtonPressTime;
  Future<bool> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) > const Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ShowSnackBar().showSnackBar(
        'Повторите,чтобы выйти из приложения',
        duration: const Duration(seconds: 2),
        noAction: true,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Hive.box('settings').get('darkMode', defaultValue: true) as bool? ??
            true;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () => handleWillPop(context),
        child: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: Hive.box('settings').listenable(),
              child: GetBuilder<TabsController>(
                initState: (_) => controller.checkVersion(context),
                builder: (controller) {
                  return IndexedStack(
                      index: controller.selectedIndex,
                      children: _widgetOptions);
                },
              ),
              builder: (_, Box box, Widget? widget) {
                return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          (box.get('darkMode', defaultValue: true) as bool? ??
                                  true)
                              ? currentTheme.currentColor().withOpacity(0.5)
                              : const Color.fromRGBO(250, 248, 249, 1),
                          (box.get('darkMode', defaultValue: true) as bool? ??
                                  true)
                              ? currentTheme.getCanvasColor()
                              : const Color.fromRGBO(250, 248, 249, 1)
                        ],
                        center: const Alignment(-1, -2.3),
                        radius: 1.5,
                      ),
                    ),
                    child: widget);
              }),
        ),
      ),
      bottomSheet: const SafeArea(
        child: MiniPlayer(),
      ),
      bottomNavigationBar: GetBuilder<TabsController>(
        builder: (controller) {
          return SafeArea(
            child: CustomAnimatedBottomBar(
              containerHeight: 60,
              selectedIndex: controller.selectedIndex,
              showElevation: true,
              itemCornerRadius: 24,
              curve: Curves.easeIn,
              onItemSelected: (val) {
                controller.changePage(val);
              },
              items: [
                BottomNavyBarItem(
                  icon: const Icon(Icons.home_rounded),
                  title: const Text('Главная'),
                  activeColor: Colors.green,
                  inactiveColor: !isDarkMode ? Colors.grey[800] : Colors.white,
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.search_rounded),
                  title: const Text('Поиск'),
                  activeColor: Colors.cyan,
                  inactiveColor: !isDarkMode ? Colors.grey[800] : Colors.white,
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.library_music_rounded),
                  title: const Text('Моя медиатека'),
                  activeColor: Colors.amberAccent,
                  inactiveColor: !isDarkMode ? Colors.grey[800] : Colors.white,
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.settings),
                  title: const Text('Настройки'),
                  activeColor: Colors.brown[300]!,
                  inactiveColor: !isDarkMode ? Colors.grey[800] : Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
