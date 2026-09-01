// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'dB मीटर';

  @override
  String get decibelMeter => 'डेसिबल मीटर';

  @override
  String get current => 'वर्तमान';

  @override
  String peak(String value) {
    return 'शिखर: $value dB';
  }

  @override
  String get measuring => 'माप रहा है...';

  @override
  String get tapToStart => 'माप शुरू करने के लिए नीचे दिए गए बटन पर टैप करें';

  @override
  String get tapToStartLandscape => 'माप शुरू करने के लिए बटन पर टैप करें';

  @override
  String get startMeasuring => 'माप शुरू करें';

  @override
  String get stop => 'रोकें';

  @override
  String get permissionDenied =>
      'परिवेश ध्वनि स्तर मापने के लिए कृपया माइक्रोफोन पहुंच की अनुमति दें';

  @override
  String micError(String error) {
    return 'माइक्रोफोन शुरू करने में असमर्थ: $error';
  }

  @override
  String average(String value) {
    return 'औसत: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => 'आंकड़े';

  @override
  String min(String value) {
    return 'न्यून: $value dB';
  }

  @override
  String get initializing => 'आरंभ कर रहे हैं...';

  @override
  String get measurementInfo => 'माप जानकारी';

  @override
  String get measurementRules => 'माप नियम';

  @override
  String get measurementRulesContent =>
      '• रिकॉर्डिंग शुरू होने के 3 सेकंड बाद माप शुरू होता है\n• यह देरी माइक्रोफोन को स्थिर करने की अनुमति देकर सटीक रीडिंग सुनिश्चित करती है\n• आंकड़े (न्यूनतम, औसत, प्रतिशत) केवल प्रारंभिक 3-सेकंड अवधि के बाद गणना की जाती है\n• वर्तमान डेसिबल मान पूरे माप के दौरान वास्तविक समय में प्रदर्शित होता है\n• सर्वोत्तम परिणामों के लिए, माप के दौरान डिवाइस को स्थिर रखें';

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
