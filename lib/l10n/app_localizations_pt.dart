// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'CS Medidor de Decibéis';

  @override
  String get decibelMeter => 'Medidor de Decibéis';

  @override
  String get current => 'Atual';

  @override
  String peak(String value) {
    return 'Pico $value dB';
  }

  @override
  String get measuring => 'Medindo...';

  @override
  String get tapToStart => 'Toque no botão abaixo para começar a medir';

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
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'CS Medidor de Decibéis';

  @override
  String get decibelMeter => 'Medidor de Decibéis';

  @override
  String get current => 'Atual';

  @override
  String peak(String value) {
    return 'Pico $value dB';
  }

  @override
  String get measuring => 'Medindo...';

  @override
  String get tapToStart => 'Toque no botão abaixo para começar a medir';

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
}
