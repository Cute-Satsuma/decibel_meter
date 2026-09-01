// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Шумомер';

  @override
  String get decibelMeter => 'Измеритель Децибел';

  @override
  String get current => 'Текущий';

  @override
  String peak(String value) {
    return 'Пик: $value дБ';
  }

  @override
  String get measuring => 'Измерение...';

  @override
  String get tapToStart => 'Нажмите кнопку ниже, чтобы начать измерение';

  @override
  String get tapToStartLandscape => 'Нажмите кнопку, чтобы начать измерение';

  @override
  String get startMeasuring => 'Начать Измерение';

  @override
  String get stop => 'Остановить';

  @override
  String get permissionDenied =>
      'Пожалуйста, разрешите доступ к микрофону для измерения уровня окружающего звука';

  @override
  String micError(String error) {
    return 'Не удалось запустить микрофон: $error';
  }

  @override
  String average(String value) {
    return 'Ср: $value дБ';
  }

  @override
  String percentile(int percentile, String value) {
    return 'P$percentile: $value дБ';
  }

  @override
  String get statistics => 'Статистика';

  @override
  String min(String value) {
    return 'Мин: $value дБ';
  }

  @override
  String get initializing => 'Инициализация...';

  @override
  String get measurementInfo => 'Информация об измерении';

  @override
  String get measurementRules => 'Правила измерения';

  @override
  String get measurementRulesContent =>
      '• Измерение начинается через 3 секунды после начала записи\n• Эта задержка обеспечивает точные показания, позволяя микрофону стабилизироваться\n• Статистика (мин, среднее, процентили) рассчитывается только после начального 3-секундного периода\n• Текущее значение децибел отображается в реальном времени на протяжении всего измерения\n• Для лучших результатов держите устройство неподвижно во время измерения';

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
