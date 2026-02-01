// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'CS デシベルメーター';

  @override
  String get decibelMeter => 'デシベルメーター';

  @override
  String get current => '現在';

  @override
  String peak(String value) {
    return 'ピーク $value dB';
  }

  @override
  String get measuring => '測定中...';

  @override
  String get tapToStart => '下のボタンをタップして測定を開始';

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
}
