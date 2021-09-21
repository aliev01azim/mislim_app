import 'package:flutter/material.dart';

import 'colors.dart';
import 'splash_effect.dart';

final ThemeData defaultTheme = _buildDefaultTheme();
ThemeData _buildDefaultTheme() {
  return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colorss.dark,
          iconTheme: IconThemeData(color: Colors.white)),
      primaryColor: Colorss.primary,
      scaffoldBackgroundColor: Colorss.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return const Color.fromRGBO(97, 62, 234, 0.5);
                }
                return Colorss.primary; // Use the component's default.
              },
            ),
            fixedSize:
                MaterialStateProperty.all(const Size(double.infinity, 56))),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
      ),
      accentColor: Colors.transparent,
      cardTheme: const CardTheme(
        margin: EdgeInsets.only(top: 20),
        elevation: 3,
        shadowColor: Color.fromRGBO(122, 122, 123, 0.32),
      ),
      splashFactory: WaveSplash.customSplashFactory());
}
