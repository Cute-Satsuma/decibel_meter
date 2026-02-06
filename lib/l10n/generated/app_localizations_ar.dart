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

  @override
  String average(String value) {
    return 'المتوسط: $value ديسيبل';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value ديسيبل';
  }

  @override
  String get statistics => 'الإحصائيات';

  @override
  String min(String value) {
    return 'الحد الأدنى: $value ديسيبل';
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
}
