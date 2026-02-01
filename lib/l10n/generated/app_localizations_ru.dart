// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'CS Измеритель Децибел';

  @override
  String get decibelMeter => 'Измеритель Децибел';

  @override
  String get current => 'Текущий';

  @override
  String peak(String value) {
    return 'Пик $value дБ';
  }

  @override
  String get measuring => 'Измерение...';

  @override
  String get tapToStart => 'Нажмите кнопку ниже, чтобы начать измерение';

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
    return 'Среднее: $value дБ';
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
}
