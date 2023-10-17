import 'package:chat/common/utils/colors.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:flutter/material.dart';

ThemeData getThemeData(SelectThemeEnum theme) {
  if (theme == SelectThemeEnum.dark) {
    return ThemeData.dark().copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: DarkThemeColors.buttomColor,
              foregroundColor: Colors
                  .white // Sets color for all the descendant ElevatedButtons
              ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: DarkThemeColors.floatAxtionButtonBackgroundColor),
        dividerTheme:
            const DividerThemeData(color: DarkThemeColors.dividerColor),
        scaffoldBackgroundColor: DarkThemeColors.backgroundColor,
        appBarTheme: const AppBarTheme(
            color: DarkThemeColors.appBarColor,
            foregroundColor: DarkThemeColors.appBarForgroundColor,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: DarkThemeColors.appBarForgroundColor,
            )),
        tabBarTheme: const TabBarTheme(
          labelColor: DarkThemeColors.selectedLableColor,
          unselectedLabelStyle: TextStyle(color: LightThemeColors.tabColor),
          labelStyle: TextStyle(
            color: LightThemeColors.greyColor,
          ),
          // labelColor: LightThemeColors.greyColor,
          unselectedLabelColor: LightThemeColors.greyColor,
          indicatorColor: LightThemeColors.tabColor,
        ),
        cardTheme: const CardTheme(color: DarkThemeColors.messageColor),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: DarkThemeColors.tabColor),
        textTheme: const TextTheme(
            bodyMedium:
                TextStyle(fontSize: 16, color: DarkThemeColors.textColor),
            bodySmall: TextStyle(
              fontSize: 14,
              color: DarkThemeColors.textColor,
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              color: DarkThemeColors.textColor,
            ),
            labelSmall: TextStyle(
              fontSize: 10,
              color: DarkThemeColors.textColor,
            )),
        dialogTheme: const DialogTheme(
            contentTextStyle: TextStyle(
              fontSize: 15,
              color: DarkThemeColors.textColor,
            ),
            titleTextStyle: TextStyle(
              fontSize: 18,
              color: DarkThemeColors.textColor,
            )));
  } else {
    return ThemeData.light().copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: LightThemeColors
              .buttomColor, // Sets color for all the descendant ElevatedButtons
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: LightThemeColors.floatAxtionButtonBackgroundColor),
      dividerTheme:
          const DividerThemeData(color: LightThemeColors.dividerColor),
      scaffoldBackgroundColor: LightThemeColors.backgroundColor,
      appBarTheme: const AppBarTheme(
          color: LightThemeColors.appBarColor,
          foregroundColor: LightThemeColors.appBarForgroundColor,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: LightThemeColors.appBarForgroundColor,
          )),
      tabBarTheme: const TabBarTheme(
        labelColor: LightThemeColors.selectedLableColor,
        labelStyle: TextStyle(
          color: LightThemeColors.greyColor,
        ),
        // labelColor: LightThemeColors.greyColor,
        unselectedLabelColor: LightThemeColors.greyColor,
        indicatorColor: LightThemeColors.appBarForgroundColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: LightThemeColors.backgroundColor,
        iconColor: LightThemeColors.appBarForgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
      cardTheme: const CardTheme(
        color: LightThemeColors.messageColor,
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: LightThemeColors.tabColor),
      textTheme: const TextTheme(
        bodySmall: TextStyle(
          fontSize: 14,
          color: LightThemeColors.textColor,
        ),
        bodyMedium: TextStyle(fontSize: 16, color: LightThemeColors.textColor),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: LightThemeColors.textColor,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          color: LightThemeColors.textColor,
        ),
      ),
      dialogTheme: const DialogTheme(
          contentTextStyle: TextStyle(
            fontSize: 15,
            color: LightThemeColors.textColor,
          ),
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: LightThemeColors.textColor,
          )),
    );
  }
}
