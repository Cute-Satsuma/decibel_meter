// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Medidor dB';

  @override
  String get decibelMeter => 'Medidor de Decibelios';

  @override
  String get current => 'Actual';

  @override
  String peak(String value) {
    return 'Máx: $value dB';
  }

  @override
  String get measuring => 'Midiendo...';

  @override
  String get tapToStart => 'Toca el botón de abajo para comenzar a medir';

  @override
  String get tapToStartLandscape => 'Toca el botón para comenzar a medir';

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
    return 'Media: $value dB';
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

  @override
  String get history => 'Historial';

  @override
  String get noHistoryRecords => 'No hay registros históricos';

  @override
  String get deleteRecord => 'Eliminar Registro';

  @override
  String get deleteRecordConfirm =>
      '¿Está seguro de que desea eliminar este registro?';

  @override
  String get deleteAllRecords => 'Eliminar Todos los Registros';

  @override
  String get deleteAllRecordsConfirm =>
      '¿Está seguro de que desea eliminar todos los registros? Esta acción no se puede deshacer.';

  @override
  String get recordDeleted => 'Registro eliminado';

  @override
  String get allRecordsDeleted => 'Todos los registros eliminados';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

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
