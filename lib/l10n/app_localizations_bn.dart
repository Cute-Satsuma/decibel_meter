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
}
