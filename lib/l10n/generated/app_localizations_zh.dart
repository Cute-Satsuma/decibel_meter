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

  @override
  String average(String value) {
    return '平均值: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => '统计信息';

  @override
  String min(String value) {
    return '最小值: $value dB';
  }

  @override
  String get initializing => '初始化中...';

  @override
  String get measurementInfo => '测量说明';

  @override
  String get measurementRules => '测量规则';

  @override
  String get measurementRulesContent =>
      '• 录音开始3秒后才开始正式测量\n• 此延迟确保麦克风稳定，获得准确读数\n• 统计信息（最小值、平均值、百分位值）仅在3秒延迟后计算\n• 当前分贝值在整个测量过程中实时显示\n• 为获得最佳结果，测量时请保持设备稳定';
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

  @override
  String average(String value) {
    return '平均值: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => '统计信息';

  @override
  String min(String value) {
    return '最小值: $value dB';
  }

  @override
  String get initializing => '初始化中...';

  @override
  String get measurementInfo => '测量说明';

  @override
  String get measurementRules => '测量规则';

  @override
  String get measurementRulesContent =>
      '• 录音开始3秒后才开始正式测量\n• 此延迟确保麦克风稳定，获得准确读数\n• 统计信息（最小值、平均值、百分位值）仅在3秒延迟后计算\n• 当前分贝值在整个测量过程中实时显示\n• 为获得最佳结果，测量时请保持设备稳定';
}
