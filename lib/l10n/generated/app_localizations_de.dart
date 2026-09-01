// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'dB-Messer';

  @override
  String get decibelMeter => 'Dezibel-Messgerät';

  @override
  String get current => 'Aktuell';

  @override
  String peak(String value) {
    return 'Max: $value dB';
  }

  @override
  String get measuring => 'Messen...';

  @override
  String get tapToStart =>
      'Tippen Sie auf die Schaltfläche unten, um mit der Messung zu beginnen';

  @override
  String get tapToStartLandscape =>
      'Tippen Sie auf die Schaltfläche, um mit der Messung zu beginnen';

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

  @override
  String average(String value) {
    return 'Mittel: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => 'Statistiken';

  @override
  String min(String value) {
    return 'Min: $value dB';
  }

  @override
  String get initializing => 'Initialisierung...';

  @override
  String get measurementInfo => 'Messinformationen';

  @override
  String get measurementRules => 'Messregeln';

  @override
  String get measurementRulesContent =>
      '• Die Messung beginnt 3 Sekunden nach Beginn der Aufnahme\n• Diese Verzögerung gewährleistet genaue Messwerte, indem das Mikrofon Zeit zur Stabilisierung erhält\n• Statistiken (Min, Durchschnitt, Perzentile) werden nur nach der anfänglichen 3-Sekunden-Periode berechnet\n• Der aktuelle Dezibelwert wird während der gesamten Messung in Echtzeit angezeigt\n• Für beste Ergebnisse halten Sie das Gerät während der Messung ruhig';

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
