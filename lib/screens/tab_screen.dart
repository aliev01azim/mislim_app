import 'package:aidar_zakaz/controllers/tab_controller.dart';
import 'package:aidar_zakaz/screens/home_screen.dart';
import 'package:aidar_zakaz/screens/search_screen.dart';
import 'package:aidar_zakaz/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabScreen extends GetView<TabScreenController> {
  TabScreen({Key? key}) : super(key: key);

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
    // YourLibraryScreen(),
    // PremiumScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabScreenController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colorss.primary,
                    Colorss.dark,
                  ],
                  center: Alignment(-1, -2.2),
                  radius: 1.5,
                ),
              ),
              child: IndexedStack(
                  index: controller.selectedIndex, children: _widgetOptions),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colorss.dark,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colorss.primary,
            unselectedFontSize: 10,
            iconSize: 26,
            unselectedLabelStyle: const TextStyle(color: Colors.white),
            selectedFontSize: 10,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Главная',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Поиск',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music_rounded),
                label: 'Библиотека',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Настройки',
              ),
            ],
            currentIndex: controller.selectedIndex,
            onTap: (val) => controller.changePage(val),
          ),
        );
      },
    );
  }
}
