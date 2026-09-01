import 'package:flutter/material.dart';

enum AppPalette { orange, green, teal, blue, slate, paper }

enum AppBrightnessMode { system, light, dark }

enum AppTypeface { rounded, maru, xiaowei, nunito, system }

class PaletteSpec {
  const PaletteSpec({
    required this.primary,
    required this.primarySoft,
    required this.seedLight,
    required this.seedDark,
  });

  final Color primary;
  final Color primarySoft;
  final Color seedLight;
  final Color seedDark;
}

const paletteSpecs = <AppPalette, PaletteSpec>{
  AppPalette.orange: PaletteSpec(
    primary: Color(0xFFE65100),
    primarySoft: Color(0xFFFFB74D),
    seedLight: Color(0xFFBF360C),
    seedDark: Color(0xFFFF9800),
  ),
  AppPalette.green: PaletteSpec(
    primary: Color(0xFF2E7D32),
    primarySoft: Color(0xFF81C784),
    seedLight: Color(0xFF1B5E20),
    seedDark: Color(0xFF4CAF50),
  ),
  AppPalette.teal: PaletteSpec(
    primary: Color(0xFF00897B),
    primarySoft: Color(0xFF80CBC4),
    seedLight: Color(0xFF004D40),
    seedDark: Color(0xFF26A69A),
  ),
  AppPalette.blue: PaletteSpec(
    primary: Color(0xFF1565C0),
    primarySoft: Color(0xFF90CAF9),
    seedLight: Color(0xFF0D47A1),
    seedDark: Color(0xFF42A5F5),
  ),
  AppPalette.slate: PaletteSpec(
    primary: Color(0xFF455A64),
    primarySoft: Color(0xFF90A4AE),
    seedLight: Color(0xFF263238),
    seedDark: Color(0xFF78909C),
  ),
  AppPalette.paper: PaletteSpec(
    primary: Color(0xFF6D4C41),
    primarySoft: Color(0xFFD7CCC8),
    seedLight: Color(0xFF4E342E),
    seedDark: Color(0xFFA1887F),
  ),
};

ThemeMode themeModeOf(AppBrightnessMode mode) => switch (mode) {
  AppBrightnessMode.system => ThemeMode.system,
  AppBrightnessMode.light => ThemeMode.light,
  AppBrightnessMode.dark => ThemeMode.dark,
};
