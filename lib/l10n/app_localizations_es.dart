// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'CS Medidor de Decibelios';

  @override
  String get decibelMeter => 'Medidor de Decibelios';

  @override
  String get current => 'Actual';

  @override
  String peak(String value) {
    return 'Pico $value dB';
  }

  @override
  String get measuring => 'Midiendo...';

  @override
  String get tapToStart => 'Toca el botón de abajo para comenzar a medir';

  @override
  String get startMeasuring => 'Comenzar Medición';

  @override
  String get stop => 'Detener';

  @override
  String get permissionDenied =>
      'Por favor permite el acceso al micrófono para medir el nivel de sonido ambiente';

  @override
  String micError(String error) {
    return 'No se puede iniciar el micrófono: $error';
  }
}
