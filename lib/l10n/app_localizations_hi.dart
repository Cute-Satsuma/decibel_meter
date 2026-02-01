// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'CS डेसिबल मीटर';

  @override
  String get decibelMeter => 'डेसिबल मीटर';

  @override
  String get current => 'वर्तमान';

  @override
  String peak(String value) {
    return 'शिखर $value dB';
  }

  @override
  String get measuring => 'माप रहा है...';

  @override
  String get tapToStart => 'माप शुरू करने के लिए नीचे दिए गए बटन पर टैप करें';

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
}
