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

  @override
  String average(String value) {
    return 'Average: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => 'Statistics';

  @override
  String min(String value) {
    return 'Min: $value dB';
  }

  @override
  String get initializing => 'Initializing...';

  @override
  String get measurementInfo => 'Measurement Information';

  @override
  String get measurementRules => 'Measurement Rules';

  @override
  String get measurementRulesContent =>
      '• Measurement starts 3 seconds after recording begins\n• This delay ensures accurate readings by allowing the microphone to stabilize\n• Statistics (min, average, percentiles) are calculated only after the initial 3-second period\n• Current decibel value is displayed in real-time throughout the measurement\n• For best results, keep the device steady during measurement';
}
