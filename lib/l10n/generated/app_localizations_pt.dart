// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Medidor dB';

  @override
  String get decibelMeter => 'Medidor de Decibéis';

  @override
  String get current => 'Atual';

  @override
  String peak(String value) {
    return 'Máx: $value dB';
  }

  @override
  String get measuring => 'Medindo...';

  @override
  String get tapToStart => 'Toque no botão abaixo para começar a medir';

  @override
  String get tapToStartLandscape => 'Toque no botão para começar a medir';

  @override
  String get startMeasuring => 'Iniciar Medição';

  @override
  String get stop => 'Parar';

  @override
  String get permissionDenied =>
      'Por favor, permita o acesso ao microfone para medir o nível de som ambiente';

  @override
  String micError(String error) {
    return 'Não foi possível iniciar o microfone: $error';
  }

  @override
  String average(String value) {
    return 'Média: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => 'Estatísticas';

  @override
  String min(String value) {
    return 'Mín: $value dB';
  }

  @override
  String get initializing => 'Inicializando...';

  @override
  String get measurementInfo => 'Informações de Medição';

  @override
  String get measurementRules => 'Regras de Medição';

  @override
  String get measurementRulesContent =>
      '• A medição começa 3 segundos após o início da gravação\n• Este atraso garante leituras precisas permitindo que o microfone se estabilize\n• As estatísticas (mín, média, percentis) são calculadas apenas após o período inicial de 3 segundos\n• O valor de decibéis atual é exibido em tempo real durante toda a medição\n• Para melhores resultados, mantenha o dispositivo estável durante a medição';

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

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'Medidor dB';

  @override
  String get decibelMeter => 'Medidor de Decibéis';

  @override
  String get current => 'Atual';

  @override
  String peak(String value) {
    return 'Máx: $value dB';
  }

  @override
  String get measuring => 'Medindo...';

  @override
  String get tapToStart => 'Toque no botão abaixo para começar a medir';

  @override
  String get tapToStartLandscape => 'Toque no botão para começar a medir';

  @override
  String get startMeasuring => 'Iniciar Medição';

  @override
  String get stop => 'Parar';

  @override
  String get permissionDenied =>
      'Por favor, permita o acesso ao microfone para medir o nível de som ambiente';

  @override
  String micError(String error) {
    return 'Não foi possível iniciar o microfone: $error';
  }

  @override
  String average(String value) {
    return 'Média: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => 'Estatísticas';

  @override
  String min(String value) {
    return 'Mín: $value dB';
  }

  @override
  String get initializing => 'Inicializando...';

  @override
  String get measurementInfo => 'Informações de Medição';

  @override
  String get measurementRules => 'Regras de Medição';

  @override
  String get measurementRulesContent =>
      '• A medição começa 3 segundos após o início da gravação\n• Este atraso garante leituras precisas permitindo que o microfone se estabilize\n• As estatísticas (mín, média, percentis) são calculadas apenas após o período inicial de 3 segundos\n• O valor de decibéis atual é exibido em tempo real durante toda a medição\n• Para melhores resultados, mantenha o dispositivo estável durante a medição';
}
