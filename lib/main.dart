import 'dart:io';

import 'package:aidar_zakaz/screens/tab_screen.dart';
import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:aidar_zakaz/utils/theme.dart';
import 'package:flutter/material.dart';
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
  await openHiveBox('cache');
  await openHiveBox('recentlyPlayed');
  await openHiveBox('songDetails', limit: true);
  await setupServiceLocator();
  runApp(
    const RestartWidget(
      child: App(),
    ),
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

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _RestartWidgetState createState() => _RestartWidgetState();

  static _RestartWidgetState of(BuildContext context) {
    return (context
            .getElementForInheritedWidgetOfExactType<_RestartInheritedWidget>()!
            .widget as _RestartInheritedWidget)
        .state;
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();
  void restartApp() async {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _RestartInheritedWidget(
      key: _key,
      state: this,
      child: widget.child,
    );
  }
}

class _RestartInheritedWidget extends InheritedWidget {
  final _RestartWidgetState state;

  const _RestartInheritedWidget({
    required Key key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: currentTheme.currentTheme(),
      theme: ThemeData(
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
        accentColor: currentTheme.currentColor(),
      ),
      darkTheme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
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
        cardColor: currentTheme.getCardColor(),
        dialogBackgroundColor: currentTheme.getCardColor(),
        accentColor: currentTheme.currentColor(),
      ),
      title: 'Islamic lectures',
      initialBinding: HomeScreenBinding(),
      home: TabScreen(),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
