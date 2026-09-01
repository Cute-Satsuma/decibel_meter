// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'dB মিটার';

  @override
  String get decibelMeter => 'ডেসিবেল মিটার';

  @override
  String get current => 'বর্তমান';

  @override
  String peak(String value) {
    return 'শীর্ষ: $value dB';
  }

  @override
  String get measuring => 'মাপা হচ্ছে...';

  @override
  String get tapToStart => 'মাপা শুরু করতে নীচের বোতামে ট্যাপ করুন';

  @override
  String get tapToStartLandscape => 'মাপা শুরু করতে বোতামে ট্যাপ করুন';

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
    return 'ন্যূন: $value dB';
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
