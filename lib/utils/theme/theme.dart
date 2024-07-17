import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData.light().copyWith(
      primaryColor: const Color.fromARGB(224, 76, 175, 79),
      filledButtonTheme: filledButtonTheme(),
      elevatedButtonTheme: elevatedButtonTheme(),
      inputDecorationTheme: inputDecorationTheme(),
      textButtonTheme: textButtonTheme(),
      toggleButtonsTheme: const ToggleButtonsThemeData());

  static TextButtonThemeData textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(79, 209, 222, 212),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
          foregroundColor: const Color.fromARGB(255, 122, 148, 123)),
    );
  }

  static InputDecorationTheme inputDecorationTheme() {
    return const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide:
            BorderSide(color: Color.fromARGB(255, 122, 148, 123), width: 1.5),
      ),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
    );
  }

  static FilledButtonThemeData filledButtonTheme() {
    return FilledButtonThemeData(
        style: FilledButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 0.5,
            backgroundColor: const Color.fromARGB(255, 198, 215, 202),
            maximumSize: const Size(200, 60),
            minimumSize: const Size(170, 50)));
  }

  static ElevatedButtonThemeData elevatedButtonTheme() {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 0.5,
            backgroundColor: const Color.fromARGB(198, 29, 179, 74),
            maximumSize: const Size(200, 60),
            minimumSize: const Size(170, 50)));
  }
}
