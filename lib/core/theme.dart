import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VaultColors {
  static const bg = Color(0xFF0A0A0A);
  static const surface = Color(0xFF111111);
  static const surface2 = Color(0xFF151515);
  static const border = Color(0xFF262626);
  static const borderSoft = Color(0xFF1B1B1B);
  static const text = Color(0xFFF5F5F5);
  static const muted = Color(0xFF8A8A8A);
  static const red = Color(0xFFE5484D);
  static const redSoft = Color(0xFF3A1719);
  static const green = Color(0xFF53C991);
  static const yellow = Color(0xFFE5B94D);
}

ThemeData vaultTheme() {
  final scheme = const ColorScheme.dark(
    surface: VaultColors.bg,
    primary: VaultColors.red,
    secondary: VaultColors.red,
    error: VaultColors.red,
  );
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: VaultColors.bg,
    fontFamily: 'Geist',
    useMaterial3: true,
    splashFactory: InkSparkle.splashFactory,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: VaultColors.bg,
      foregroundColor: VaultColors.text,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      color: VaultColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: VaultColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: VaultColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: VaultColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: VaultColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: VaultColors.red, width: 1.2),
      ),
    ),
    dividerTheme: const DividerThemeData(color: VaultColors.borderSoft, thickness: 1),
  );
}
