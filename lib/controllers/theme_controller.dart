import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeController with ChangeNotifier {
  bool _isDark =
      Hive.box('settings').get('darkMode', defaultValue: true) as bool;

  String? accentColor = Hive.box('settings').get('themeColor') as String?;
  String canvasColor = Hive.box('settings')
      .get('canvasColor', defaultValue: 'Темно-синий') as String;

  int colorHue = Hive.box('settings').get('colorHue', defaultValue: 400) as int;

  void switchTheme({required bool isDark}) {
    _isDark = isDark;
    _isDark ? switchColor('Default', 100) : switchColor('Светло-Голубой', 400);
    notifyListeners();
  }

  void switchColor(String color, int? hue) {
    Hive.box('settings').put('themeColor', color);
    accentColor = color;
    Hive.box('settings').put('colorHue', hue);
    colorHue = hue!;
    notifyListeners();
  }

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  int currentHue() {
    return colorHue;
  }

  Color getColor(String color, int hue) {
    switch (color) {
      case 'Красный':
        return Colors.redAccent[hue]!;
      case 'Default':
        return Colors.tealAccent[hue]!;
      case 'Светло-Голубой':
        return Colors.lightBlueAccent[hue]!;
      case 'Желтый':
        return Colors.yellowAccent[hue]!;
      case 'Оранжевый':
        return Colors.orangeAccent[hue]!;
      case 'Голубой':
        return Colors.blueAccent[hue]!;
      case 'Синий':
        return Colors.cyanAccent[hue]!;
      case 'Лайм':
        return Colors.limeAccent[hue]!;
      case 'Розовый':
        return Colors.pinkAccent[hue]!;
      case 'Зеленый':
        return Colors.greenAccent[hue]!;
      case 'Янтарный':
        return Colors.amberAccent[hue]!;
      case 'Индиго':
        return Colors.indigoAccent[hue]!;
      case 'Фиолетовый':
        return Colors.purpleAccent[hue]!;
      case 'Насыщенный Оранжевый':
        return Colors.deepOrangeAccent[hue]!;
      case 'Темно-фиолетовый':
        return Colors.deepPurpleAccent[hue]!;
      case 'Светло-Зеленый':
        return Colors.lightGreenAccent[hue]!;

      default:
        return _isDark
            ? const Color.fromRGBO(13, 213, 80, 1)
            : Colors.lightBlueAccent[400]!;
    }
  }

  Color getCanvasColor() {
    if (canvasColor == 'Черный') return const Color.fromRGBO(19, 19, 19, 1);
    if (canvasColor == 'Темно-синий') return const Color.fromRGBO(6, 18, 40, 1);
    return const Color.fromRGBO(6, 18, 40, 1);
  }

  void switchCanvasColor(String color) {
    Hive.box('settings').put('canvasColor', color);
    canvasColor = color;
    notifyListeners();
  }

  Color currentColor() {
    switch (accentColor) {
      case 'Красный':
        return Colors.redAccent[currentHue()]!;
      case 'Default':
        return const Color.fromRGBO(13, 213, 80, 1);
      case 'Светло-Голубой':
        return Colors.lightBlueAccent[currentHue()]!;
      case 'Желтый':
        return Colors.yellowAccent[currentHue()]!;
      case 'Оранжевый':
        return Colors.orangeAccent[currentHue()]!;
      case 'Голубой':
        return Colors.blueAccent[currentHue()]!;
      case 'Синий':
        return Colors.cyanAccent[currentHue()]!;
      case 'Лайм':
        return Colors.limeAccent[currentHue()]!;
      case 'Розовый':
        return Colors.pinkAccent[currentHue()]!;
      case 'Зеленый':
        return Colors.greenAccent[currentHue()]!;
      case 'Янтарный':
        return Colors.amberAccent[currentHue()]!;
      case 'Индиго':
        return Colors.indigoAccent[currentHue()]!;
      case 'Фиолетовый':
        return Colors.purpleAccent[currentHue()]!;
      case 'Насыщенный Оранжевый':
        return Colors.deepOrangeAccent[currentHue()]!;
      case 'Темно-фиолетовый':
        return Colors.deepPurpleAccent[currentHue()]!;
      case 'Светло-Зеленый':
        return Colors.lightGreenAccent[currentHue()]!;

      default:
        return _isDark
            ? const Color.fromRGBO(13, 213, 80, 1)
            : Colors.lightBlueAccent[400]!;
    }
  }
}

ThemeController currentTheme = ThemeController();
