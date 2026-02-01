// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'CS ডেসিবেল মিটার';

  @override
  String get decibelMeter => 'ডেসিবেল মিটার';

  @override
  String get current => 'বর্তমান';

  @override
  String peak(String value) {
    return 'শীর্ষ $value dB';
  }

  @override
  String get measuring => 'মাপা হচ্ছে...';

  @override
  String get tapToStart => 'মাপা শুরু করতে নীচের বোতামে ট্যাপ করুন';

  @override
  String get startMeasuring => 'মাপা শুরু করুন';

  @override
  String get stop => 'বন্ধ করুন';

  @override
  String get permissionDenied =>
      'পরিবেশের শব্দের মাত্রা পরিমাপ করতে অনুগ্রহ করে মাইক্রোফোন অ্যাক্সেসের অনুমতি দিন';

  @override
  String micError(String error) {
    return 'মাইক্রোফোন শুরু করতে অক্ষম: $error';
  }

  @override
  String average(String value) {
    return 'গড়: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => 'পরিসংখ্যান';

  @override
  String min(String value) {
    return 'সর্বনিম্ন: $value dB';
  }

  @override
  String get initializing => 'আরম্ভ হচ্ছে...';

  @override
  String get measurementInfo => 'মাপার তথ্য';

  @override
  String get measurementRules => 'মাপার নিয়ম';

  @override
  String get measurementRulesContent =>
      '• রেকর্ডিং শুরু হওয়ার 3 সেকেন্ড পরে মাপা শুরু হয়\n• এই বিলম্ব মাইক্রোফোনকে স্থিতিশীল করতে দিয়ে সঠিক রিডিং নিশ্চিত করে\n• পরিসংখ্যান (সর্বনিম্ন, গড়, পার্সেন্টাইল) শুধুমাত্র প্রাথমিক 3-সেকেন্ড সময়ের পরে গণনা করা হয়\n• বর্তমান ডেসিবেল মান পুরো মাপার সময় বাস্তব সময়ে প্রদর্শিত হয়\n• সেরা ফলাফলের জন্য, মাপার সময় ডিভাইস স্থির রাখুন';
}
