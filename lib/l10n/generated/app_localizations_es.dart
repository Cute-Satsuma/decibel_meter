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

  @override
  String average(String value) {
    return 'Promedio: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => 'Estadísticas';

  @override
  String min(String value) {
    return 'Mín: $value dB';
  }

  @override
  String get initializing => 'Inicializando...';

  @override
  String get measurementInfo => 'Información de Medición';

  @override
  String get measurementRules => 'Reglas de Medición';

  @override
  String get measurementRulesContent =>
      '• La medición comienza 3 segundos después de iniciar la grabación\n• Este retraso asegura lecturas precisas permitiendo que el micrófono se estabilice\n• Las estadísticas (mín, promedio, percentiles) se calculan solo después del período inicial de 3 segundos\n• El valor de decibelios actual se muestra en tiempo real durante toda la medición\n• Para mejores resultados, mantenga el dispositivo estable durante la medición';
}
