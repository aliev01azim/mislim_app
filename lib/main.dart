import 'package:aidar_zakaz/bindings/tab_screen_binding.dart';
import 'package:aidar_zakaz/screens/tab_screen.dart';
import 'package:aidar_zakaz/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: defaultTheme,
      title: 'Islamic lectures',
      initialBinding: HomeScreenBinding(),
      home: TabScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
