// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '分贝仪';

  @override
  String get decibelMeter => '分贝仪';

  @override
  String get current => '当前';

  @override
  String peak(String value) {
    return '峰值: $value dB';
  }

  @override
  String get measuring => '正在测量…';

  @override
  String get tapToStart => '点击下方按钮开始测量';

  @override
  String get tapToStartLandscape => '点击按钮开始测量';

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
    return '平均: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => '统计信息';

  @override
  String min(String value) {
    return '最小: $value dB';
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

  @override
  String get history => '历史记录';

  @override
  String get noHistoryRecords => '暂无历史记录';

  @override
  String get deleteRecord => '删除记录';

  @override
  String get deleteRecordConfirm => '确定要删除这条记录吗？';

  @override
  String get deleteAllRecords => '删除所有记录';

  @override
  String get deleteAllRecordsConfirm => '确定要删除所有记录吗？此操作无法撤销。';

  @override
  String get recordDeleted => '记录已删除';

  @override
  String get allRecordsDeleted => '所有记录已删除';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get settingsTitle => '设置';

  @override
  String get aboutTitle => '关于';

  @override
  String get aboutContent =>
      '环境音量分贝仪。\n\n• 无广告、无需账号\n• 历史记录只保存在本机\n• 仅在测量时使用麦克风\n• 读数供日常参考，不能替代实验室校准设备';

  @override
  String get brandTitle => '品牌';

  @override
  String get brandContent => 'Caju（可爱桔）是 Cute-Satsuma 旗下的独立应用品牌。';

  @override
  String get brandTagline => 'Cute-Satsuma · Caju · 可爱桔';

  @override
  String versionLabel(String version) {
    return '版本 $version';
  }

  @override
  String buildLabel(String build) {
    return '构建 $build';
  }

  @override
  String get privacyPolicyLink => '隐私政策';

  @override
  String get productPageLink => '产品主页';

  @override
  String get themeColor => '配色';

  @override
  String get themeOrange => '柑色';

  @override
  String get themeGreen => '绿色';

  @override
  String get themeTeal => '青绿';

  @override
  String get themeBlue => '蓝色';

  @override
  String get themeSlate => '岩灰';

  @override
  String get themePaper => '纸色';

  @override
  String get themePaperFilter => '纸质滤镜';

  @override
  String get themeGuideTitle => '换个主题';

  @override
  String get themeGuideBody => '点这里就能改配色、外观和字体。';

  @override
  String get themeGotIt => '知道了';

  @override
  String get themePickerTitle => '选一个喜欢的颜色';

  @override
  String get themePickerBody => '点色块即可预览，之后仍可在设置里更改。';

  @override
  String get themePickerContinue => '选好了';

  @override
  String get themePickerPaperBody => '打开后会给界面加上纸张纹理。';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get appName => '分贝仪';

  @override
  String get decibelMeter => '分贝仪';

  @override
  String get current => '当前';

  @override
  String peak(String value) {
    return '峰值: $value dB';
  }

  @override
  String get measuring => '正在测量…';

  @override
  String get tapToStart => '点击下方按钮开始测量';

  @override
  String get tapToStartLandscape => '点击按钮开始测量';

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
    return '平均: $value dB';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value dB';
  }

  @override
  String get statistics => '统计信息';

  @override
  String min(String value) {
    return '最小: $value dB';
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

  @override
  String get settingsTitle => '设置';

  @override
  String get aboutTitle => '关于';

  @override
  String get aboutContent =>
      '环境音量分贝仪。\n\n• 无广告、无需账号\n• 历史记录只保存在本机\n• 仅在测量时使用麦克风\n• 读数供日常参考，不能替代实验室校准设备';

  @override
  String get brandTitle => '品牌';

  @override
  String get brandContent => 'Caju（可爱桔）是 Cute-Satsuma 旗下的独立应用品牌。';

  @override
  String get brandTagline => 'Cute-Satsuma · Caju · 可爱桔';

  @override
  String versionLabel(String version) {
    return '版本 $version';
  }

  @override
  String buildLabel(String build) {
    return '构建 $build';
  }

  @override
  String get privacyPolicyLink => '隐私政策';

  @override
  String get productPageLink => '产品主页';

  @override
  String get themeColor => '配色';

  @override
  String get themeOrange => '柑色';

  @override
  String get themeGreen => '绿色';

  @override
  String get themeTeal => '青绿';

  @override
  String get themeBlue => '蓝色';

  @override
  String get themeSlate => '岩灰';

  @override
  String get themePaper => '纸色';

  @override
  String get themePaperFilter => '纸质滤镜';

  @override
  String get themeGuideTitle => '换个主题';

  @override
  String get themeGuideBody => '点这里就能改配色、外观和字体。';

  @override
  String get themeGotIt => '知道了';

  @override
  String get themePickerTitle => '选一个喜欢的颜色';

  @override
  String get themePickerBody => '点色块即可预览，之后仍可在设置里更改。';

  @override
  String get themePickerContinue => '选好了';

  @override
  String get themePickerPaperBody => '打开后会给界面加上纸张纹理。';
}
