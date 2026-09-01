// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'dBメーター';

  @override
  String get decibelMeter => 'デシベルメーター';

  @override
  String get current => '現在';

  @override
  String peak(String value) {
    return 'ピーク: $value dB';
  }

  @override
  String get measuring => '測定中...';

  @override
  String get tapToStart => '下のボタンをタップして測定を開始';

  @override
  String get tapToStartLandscape => 'ボタンをタップして測定を開始';

  @override
  String get startMeasuring => '測定開始';

  @override
  String get stop => '停止';

  @override
  String get permissionDenied => '周囲の音レベルを測定するには、マイクへのアクセスを許可してください';

  @override
  String micError(String error) {
    return 'マイクを開始できません: $error';
  }

  @override
  String average(String value) {
    return '平均: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => '統計';

  @override
  String min(String value) {
    return '最小: $value dB';
  }

  @override
  String get initializing => '初期化中...';

  @override
  String get measurementInfo => '測定情報';

  @override
  String get measurementRules => '測定ルール';

  @override
  String get measurementRulesContent =>
      '• 録音開始から3秒後に測定を開始します\n• この遅延により、マイクが安定し、正確な測定値が得られます\n• 統計情報（最小値、平均値、パーセンタイル）は初期3秒間の後でのみ計算されます\n• 現在のデシベル値は測定全体を通じてリアルタイムで表示されます\n• 最良の結果を得るには、測定中はデバイスを安定させてください';

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
