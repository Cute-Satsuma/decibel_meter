import 'package:decibel_meter/theme/app_palette.dart';
import 'package:decibel_meter/theme/caju_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData buildAppTheme(
  AppPalette palette,
  Brightness brightness, {
  AppTypeface typeface = AppTypeface.rounded,
  bool paperFilter = false,
}) {
  final dark = brightness == Brightness.dark;
  final spec = paletteSpecs[palette]!;
  var scheme = ColorScheme.fromSeed(
    seedColor: dark ? spec.seedDark : spec.seedLight,
    brightness: brightness,
    primary: dark ? spec.primarySoft : spec.primary,
  );
  if (palette == AppPalette.paper) {
    scheme = dark
        ? scheme.copyWith(
            surface: const Color(0xFF2A2218),
            onSurface: const Color(0xFFE8D9C0),
          )
        : scheme.copyWith(
            surface: const Color(0xFFF3E6CF),
            onSurface: const Color(0xFF3E2F1C),
          );
  } else {
    scheme = dark
        ? scheme.copyWith(
            surface: const Color(0xFF191A17),
            surfaceContainerLowest: const Color(0xFF141512),
            surfaceContainerLow: const Color(0xFF20211D),
            surfaceContainer: const Color(0xFF252620),
            outlineVariant: const Color(0xFF45483F),
          )
        : scheme.copyWith(
            surface: const Color(0xFFFBFAF4),
            surfaceContainerLowest: const Color(0xFFFFFEF8),
            surfaceContainerLow: const Color(0xFFF5F3E9),
            surfaceContainer: const Color(0xFFEDEBE0),
            outlineVariant: const Color(0xFFD7D5C9),
          );
  }
  final base = ThemeData(colorScheme: scheme, useMaterial3: true).textTheme;
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    textTheme: cajuTextTheme(base, typeface),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: scheme.primary,
      surfaceTintColor: Colors.transparent,
      // Transparent AppBar is Color(0x00000000); without an explicit overlay
      // Flutter treats it as dark and paints light status-bar icons on paper.
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
        statusBarBrightness: dark ? Brightness.dark : Brightness.light,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
    bottomSheetTheme: BottomSheetThemeData(
      showDragHandle: true,
      backgroundColor: scheme.surface,
      modalBackgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
    ),
    extensions: [CajuThemeExtras(paperFilter: paperFilter)],
  );
}

class CajuThemeExtras extends ThemeExtension<CajuThemeExtras> {
  const CajuThemeExtras({required this.paperFilter});
  final bool paperFilter;

  @override
  CajuThemeExtras copyWith({bool? paperFilter}) =>
      CajuThemeExtras(paperFilter: paperFilter ?? this.paperFilter);

  @override
  CajuThemeExtras lerp(covariant CajuThemeExtras? other, double t) =>
      CajuThemeExtras(
        paperFilter: other == null || t < .5 ? paperFilter : other.paperFilter,
      );
}
