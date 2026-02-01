// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CS Decibel Meter';

  @override
  String get decibelMeter => 'Decibel Meter';

  @override
  String get current => 'Current';

  @override
  String peak(String value) {
    return 'Peak $value dB';
  }

  @override
  String get measuring => 'Measuring...';

  @override
  String get tapToStart => 'Tap the button below to start measuring';

  @override
  String get startMeasuring => 'Start Measuring';

  @override
  String get stop => 'Stop';

  @override
  String get permissionDenied =>
      'Please allow microphone access to measure ambient sound level';

  @override
  String micError(String error) {
    return 'Unable to start microphone: $error';
  }
}
