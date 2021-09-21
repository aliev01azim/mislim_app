import 'package:aidar_zakaz/screens/tab_screen.dart';
import 'package:aidar_zakaz/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'all_about_audio/services/service_locator.dart';
import 'bindings/home_screen_binding.dart';
import 'utils/scroll_glow.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await setupServiceLocator();
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
