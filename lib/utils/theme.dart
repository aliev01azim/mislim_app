import 'package:aidar_zakaz/utils/custom_route.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

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
    // textTheme: _buildDefaultTextTheme(),
    // pageTransitionsTheme: PageTransitionsTheme(builders: {
    //   TargetPlatform.android: CustomPageTransitionBuilder(),
    //   TargetPlatform.iOS: CustomPageTransitionBuilder(),
    // }),
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
    cardTheme: const CardTheme(
      margin: EdgeInsets.only(top: 20),
      elevation: 3,
      shadowColor: Color.fromRGBO(122, 122, 123, 0.32),
    ),
  );
}

TextTheme _buildDefaultTextTheme() {
  return const TextTheme(
    button: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: Colors.white,
        fontSize: 16),
    // slider title

    // addCardScreen text

    // logo snizu

    // defaultBodyText

    // form input values style

    // slider body text
  );
}
