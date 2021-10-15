import 'dart:async';
import 'dart:io';

import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/screens/tab_screen.dart';
import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bindings/home_screen_binding.dart';
import 'utils/scroll_glow.dart';
import 'package:path_provider/path_provider.dart';

import 'utils/splash_effect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await openHiveBox('settings');
  await openHiveBox('favorites', limit: true);
  await openHiveBox('recentlyPlayed', limit: true);
  await Hive.box('recentlyPlayed').clear();
  await Hive.box('favorites').clear();
  await setupServiceLocator();
  runApp(
    const App(),
  );
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  if (limit) {
    final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      final File dbFile = File('$dirPath/$boxName.hive');
      final File lockFile = File('$dirPath/$boxName.lock');
      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox(boxName);
      throw 'Failed to open $boxName Box\nError: $error';
    });
    // clear box if it grows large
    if (box.length > 1000) {
      box.clear();
    }
    await Hive.openBox(boxName);
  } else {
    await Hive.openBox(boxName).onError((error, stackTrace) async {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      final File dbFile = File('$dirPath/$boxName.hive');
      final File lockFile = File('$dirPath/$boxName.lock');
      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox(boxName);
      throw 'Failed to open $boxName Box\nError: $error';
    });
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        child: TabScreen(),
        builder: (_, Box box, Widget? widget) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor:
                  (box.get('darkMode', defaultValue: true) as bool? ?? true)
                      ? currentTheme.getCanvasColor()
                      : currentTheme.currentColor().withOpacity(0.5),
            ),
          );
          return GetMaterialApp(
            themeMode:
                (box.get('darkMode', defaultValue: true) as bool? ?? true)
                    ? ThemeMode.dark
                    : ThemeMode.light,
            theme: !(box.get('darkMode', defaultValue: true) as bool? ?? true)
                ? ThemeData(
                    pageTransitionsTheme: const PageTransitionsTheme(
                      builders: <TargetPlatform, PageTransitionsBuilder>{
                        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
                        TargetPlatform.android: ZoomPageTransitionsBuilder(),
                      },
                    ),
                    textTheme: const TextTheme(
                      bodyText1: TextStyle(color: Colors.black),
                      bodyText2: TextStyle(color: Colors.black),
                      subtitle1: TextStyle(color: Colors.black),
                      subtitle2: TextStyle(color: Colors.black),
                    ),
                    textSelectionTheme: TextSelectionThemeData(
                      selectionHandleColor: currentTheme.currentColor(),
                      cursorColor: currentTheme.currentColor(),
                      selectionColor: currentTheme.currentColor(),
                    ),
                    bottomSheetTheme: const BottomSheetThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.0),
                          topRight: Radius.circular(7.0),
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    appBarTheme: AppBarTheme(
                      backgroundColor: currentTheme.currentColor(),
                    ),
                    brightness: Brightness.light,
                    splashFactory: WaveSplash.customSplashFactory(),
                    primaryColor: currentTheme.currentColor(),
                  )
                : null,
            darkTheme: (box.get('darkMode', defaultValue: true) as bool? ??
                    true)
                ? ThemeData(
                    pageTransitionsTheme: const PageTransitionsTheme(
                      builders: <TargetPlatform, PageTransitionsBuilder>{
                        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
                        TargetPlatform.android: ZoomPageTransitionsBuilder(),
                      },
                    ),
                    textTheme: const TextTheme(
                      bodyText1: TextStyle(color: Colors.white),
                      bodyText2: TextStyle(color: Colors.white),
                      subtitle1: TextStyle(color: Colors.white),
                      subtitle2: TextStyle(color: Colors.white),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                      ),
                    ),
                    bottomSheetTheme: BottomSheetThemeData(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.0),
                          topRight: Radius.circular(7.0),
                        ),
                      ),
                      backgroundColor: currentTheme.getCanvasColor(),
                    ),
                    textSelectionTheme: TextSelectionThemeData(
                      selectionHandleColor: currentTheme.currentColor(),
                      cursorColor: currentTheme.currentColor(),
                      selectionColor: currentTheme.currentColor(),
                    ),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    brightness: Brightness.dark,
                    appBarTheme: AppBarTheme(
                      color: currentTheme.getCanvasColor(),
                    ),
                    splashFactory: WaveSplash.customSplashFactory(),
                    canvasColor: currentTheme.getCanvasColor(),
                    primaryColor: currentTheme.currentColor(),
                  )
                : null,
            title: 'Islamic lectures',
            scaffoldMessengerKey: GlobalKey(debugLabel: 'messengerKey'),
            initialBinding: HomeScreenBinding(),
            home: widget,
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
