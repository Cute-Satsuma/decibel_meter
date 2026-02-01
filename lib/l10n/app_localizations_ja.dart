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
}
