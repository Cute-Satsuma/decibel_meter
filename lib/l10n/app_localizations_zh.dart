// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'CS 分贝仪';

  @override
  String get decibelMeter => '分贝仪';

  @override
  String get current => '当前';

  @override
  String peak(String value) {
    return '峰值 $value dB';
  }

  @override
  String get measuring => '正在测量…';

  @override
  String get tapToStart => '点击下方按钮开始测量';

  @override
  String get startMeasuring => '开始测量';

  @override
  String get stop => '停止';

  @override
  String get permissionDenied => '请允许使用麦克风以测量环境音量';

  @override
  String micError(String error) {
    return '无法启动麦克风: $error';
  }
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get appName => 'CS 分贝仪';

  @override
  String get decibelMeter => '分贝仪';

  @override
  String get current => '当前';

  @override
  String peak(String value) {
    return '峰值 $value dB';
  }

  @override
  String get measuring => '正在测量…';

  @override
  String get tapToStart => '点击下方按钮开始测量';

  @override
  String get startMeasuring => '开始测量';

  @override
  String get stop => '停止';

  @override
  String get permissionDenied => '请允许使用麦克风以测量环境音量';

  @override
  String micError(String error) {
    return '无法启动麦克风: $error';
  }
}
