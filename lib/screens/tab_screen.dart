import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/screens/home_screen.dart';
import 'package:aidar_zakaz/screens/search_screen.dart';
import 'package:aidar_zakaz/screens/setting.dart';
import 'package:aidar_zakaz/utils/colors.dart';
import 'package:aidar_zakaz/utils/theme.dart';
import 'package:aidar_zakaz/widgets/bottom_bar.dart';
import 'package:aidar_zakaz/widgets/miniplayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'library/library_screen.dart';

class TabScreen extends StatelessWidget {
  TabScreen({Key? key}) : super(key: key);

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
    const LibraryScreen(),
    SettingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = currentTheme.currentTheme() == ThemeMode.dark;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                currentTheme.currentColor().withOpacity(0.5),
                isDarkMode ? Colorss.dark : Colors.white
              ],
              center: const Alignment(-1, -2.3),
              radius: 1.5,
            ),
          ),
          child: GetBuilder<HomeScreenController>(
            builder: (controller) {
              return IndexedStack(
                  index: controller.selectedIndex, children: _widgetOptions);
            },
          ),
        ),
      ),
      bottomSheet: SafeArea(
        child: MiniPlayer(),
      ),
      bottomNavigationBar: GetBuilder<HomeScreenController>(
        builder: (controller) {
          return SafeArea(
            child: CustomAnimatedBottomBar(
              containerHeight: 60,
              selectedIndex: controller.selectedIndex,
              showElevation: true,
              backgroundColor: isDarkMode ? Colorss.dark : Colors.white,
              itemCornerRadius: 24,
              curve: Curves.easeIn,
              onItemSelected: (val) => controller.changePage(val),
              items: <BottomNavyBarItem>[
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
// BottomNavigationBar(
//             fixedColor: Colors.green,
//             backgroundColor: Colorss.dark,
//             unselectedItemColor: Colors.white,
//             unselectedFontSize: 10,
//             iconSize: 30,
//             unselectedIconTheme: const IconThemeData(size: 28),
//             unselectedLabelStyle: const TextStyle(color: Colors.white),
//             selectedFontSize: 11,
//             showUnselectedLabels: true,
//             type: BottomNavigationBarType.fixed,
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home_rounded),
//                 label: 'Главная',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.search_rounded),
//                 label: 'Поиск',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.library_music_rounded),
//                 label: 'Медиатека',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.settings),
//                 label: 'Настройки',
//               ),
//             ],
//             currentIndex: controller.selectedIndex,
//             onTap: (val) => controller.changePage(val),
//           );