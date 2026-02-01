// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'CS Dezibel-Messgerät';

  @override
  String get decibelMeter => 'Dezibel-Messgerät';

  @override
  String get current => 'Aktuell';

  @override
  String peak(String value) {
    return 'Spitze $value dB';
  }

  @override
  String get measuring => 'Messen...';

  @override
  String get tapToStart =>
      'Tippen Sie auf die Schaltfläche unten, um mit der Messung zu beginnen';

  @override
  String get startMeasuring => 'Messung Starten';

  @override
  String get stop => 'Stoppen';

  @override
  String get permissionDenied =>
      'Bitte erlauben Sie den Mikrofonzugriff, um den Umgebungsschallpegel zu messen';

  @override
  String micError(String error) {
    return 'Mikrofon kann nicht gestartet werden: $error';
  }
}
