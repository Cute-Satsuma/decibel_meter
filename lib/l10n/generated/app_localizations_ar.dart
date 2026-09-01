// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مقياس dB';

  @override
  String get decibelMeter => 'مقياس الديسيبل';

  @override
  String get current => 'الحالي';

  @override
  String peak(String value) {
    return 'ذروة: $value dB';
  }

  @override
  String get measuring => 'جارٍ القياس...';

  @override
  String get tapToStart => 'اضغط على الزر أدناه لبدء القياس';

  @override
  String get tapToStartLandscape => 'اضغط على الزر لبدء القياس';

  @override
  String get startMeasuring => 'بدء القياس';

  @override
  String get stop => 'إيقاف';

  @override
  String get permissionDenied =>
      'يرجى السماح بالوصول إلى الميكروفون لقياس مستوى الصوت المحيط';

  @override
  String micError(String error) {
    return 'تعذر بدء تشغيل الميكروفون: $error';
  }

  @override
  String average(String value) {
    return 'متوسط: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => 'الإحصائيات';

  @override
  String min(String value) {
    return 'أدنى: $value dB';
  }

  @override
  String get initializing => 'جارٍ التهيئة...';

  @override
  String get measurementInfo => 'معلومات القياس';

  @override
  String get measurementRules => 'قواعد القياس';

  @override
  String get measurementRulesContent =>
      '• يبدأ القياس بعد 3 ثوانٍ من بدء التسجيل\n• يضمن هذا التأخير قراءات دقيقة من خلال السماح للميكروفون بالاستقرار\n• يتم حساب الإحصائيات (الحد الأدنى، المتوسط، النسب المئوية) فقط بعد الفترة الأولية البالغة 3 ثوانٍ\n• يتم عرض قيمة الديسيبل الحالية في الوقت الفعلي طوال عملية القياس\n• للحصول على أفضل النتائج، حافظ على ثبات الجهاز أثناء القياس';

  @override
  String get history => 'History';

  @override
  String get noHistoryRecords => 'No history records';

  @override
  String get deleteRecord => 'Delete Record';

  @override
  String get deleteRecordConfirm =>
      'Are you sure you want to delete this record?';

  @override
  String get deleteAllRecords => 'Delete All Records';

  @override
  String get deleteAllRecordsConfirm =>
      'Are you sure you want to delete all records? This action cannot be undone.';

  @override
  String get recordDeleted => 'Record deleted';

  @override
  String get allRecordsDeleted => 'All records deleted';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutContent =>
      'Ambient sound level meter.\n\n• No ads and no account\n• History stays on this device\n• Microphone is used only while measuring\n• Readings are for everyday reference, not lab calibration';

  @override
  String get brandTitle => 'Brand';

  @override
  String get brandContent =>
      'Caju is a friendly indie app brand by Cute-Satsuma.';

  @override
  String get brandTagline => 'Cute-Satsuma · Caju';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String buildLabel(String build) {
    return 'Build $build';
  }

  @override
  String get privacyPolicyLink => 'Privacy policy';

  @override
  String get productPageLink => 'Product page';

  @override
  String get themeColor => 'Color';

  @override
  String get themeOrange => 'Orange';

  @override
  String get themeGreen => 'Green';

  @override
  String get themeTeal => 'Teal';

  @override
  String get themeBlue => 'Blue';

  @override
  String get themeSlate => 'Slate';

  @override
  String get themePaper => 'Paper';

  @override
  String get themePaperFilter => 'Paper texture';

  @override
  String get themeGuideTitle => 'Change the look';

  @override
  String get themeGuideBody =>
      'Tap here to switch colors, appearance, and fonts.';

  @override
  String get themeGotIt => 'Got it';

  @override
  String get themePickerTitle => 'Pick a color you like';

  @override
  String get themePickerBody =>
      'Tap a color to preview. You can change this later in Settings.';

  @override
  String get themePickerContinue => 'Choose this';

  @override
  String get themePickerPaperBody => 'Adds a light paper grain to the screen.';
}
