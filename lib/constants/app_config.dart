import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppConfig {
  static const String appName = 'Best Offers';
  static const bool isProduction = true;
  static const List<String> supportedLanguages = ['en', 'es', 'fr', 'ar'];

  static TextStyle get _style => GoogleFonts.cairo(
    color: AppColors.textColor,
  );

  static ThemeData themeData = ThemeData(
    primarySwatch: _convertColor(AppColors.primaryColor),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    useMaterial3: true,
    textTheme: TextTheme(
      bodySmall: _style.copyWith(fontSize: 11),
      bodyMedium: _style.copyWith(fontSize: 15),
      bodyLarge: _style.copyWith(fontSize: 18),
      titleSmall: _style.copyWith(fontSize: 11),
      titleMedium: _style.copyWith(fontSize: 15),
      titleLarge: _style.copyWith(fontSize: 18),
      labelSmall: _style.copyWith(fontSize: 11),
      labelMedium: _style.copyWith(fontSize: 15),
      labelLarge: _style.copyWith(fontSize: 18),
      displaySmall: _style.copyWith(fontSize: 11),
      displayMedium: _style.copyWith(fontSize: 15),
      displayLarge: _style.copyWith(fontSize: 18),
    ),
    dialogTheme: DialogTheme(
      titleTextStyle: _style.copyWith(
        color: AppColors.backgroundColor,
        fontSize: 18,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.accentColor,
      size: 20,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: _style.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: AppColors.textColor,
      ),
      color: AppColors.backgroundColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: _style.copyWith(fontSize: 13)
    )
  );



  static MaterialColor _convertColor(Color myColor){
    return MaterialColor(
      myColor.value,
      <int, Color>{
        50: myColor.withOpacity(0.1),
        100: myColor.withOpacity(0.2),
        200: myColor.withOpacity(0.3),
        300: myColor.withOpacity(0.4),
        400: myColor.withOpacity(0.5),
        500: myColor.withOpacity(0.6),
        600: myColor.withOpacity(0.7),
        700: myColor.withOpacity(0.8),
        800: myColor.withOpacity(0.9),
        900: myColor.withOpacity(1.0),
      },
    );
  }
}
