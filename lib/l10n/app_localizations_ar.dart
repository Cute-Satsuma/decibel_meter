// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'CS مقياس الديسيبل';

  @override
  String get decibelMeter => 'مقياس الديسيبل';

  @override
  String get current => 'الحالي';

  @override
  String peak(String value) {
    return 'الذروة $value ديسيبل';
  }

  @override
  String get measuring => 'جارٍ القياس...';

  @override
  String get tapToStart => 'اضغط على الزر أدناه لبدء القياس';

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
}
