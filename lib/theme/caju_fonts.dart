import 'package:decibel_meter/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme cajuTextTheme(TextTheme base, AppTypeface typeface) =>
    switch (typeface) {
      AppTypeface.rounded => GoogleFonts.mPlusRounded1cTextTheme(base),
      AppTypeface.maru => GoogleFonts.zenMaruGothicTextTheme(base),
      AppTypeface.xiaowei => GoogleFonts.zcoolXiaoWeiTextTheme(base),
      AppTypeface.nunito => GoogleFonts.nunitoTextTheme(base),
      AppTypeface.system => base,
    };

TextStyle cajuPreviewStyle(AppTypeface typeface, TextStyle? base) {
  final style = (base ?? const TextStyle()).copyWith(fontSize: 13);
  return switch (typeface) {
    AppTypeface.rounded => GoogleFonts.mPlusRounded1c(textStyle: style),
    AppTypeface.maru => GoogleFonts.zenMaruGothic(textStyle: style),
    AppTypeface.xiaowei => GoogleFonts.zcoolXiaoWei(textStyle: style),
    AppTypeface.nunito => GoogleFonts.nunito(textStyle: style),
    AppTypeface.system => style,
  };
}
