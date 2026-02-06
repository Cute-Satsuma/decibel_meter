import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('zh'),
    Locale('zh', 'CN'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'CS Decibel Meter'**
  String get appName;

  /// Main title
  ///
  /// In en, this message translates to:
  /// **'Decibel Meter'**
  String get decibelMeter;

  /// Current decibel label
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// Peak decibel value
  ///
  /// In en, this message translates to:
  /// **'Peak {value} dB'**
  String peak(String value);

  /// Status when measuring
  ///
  /// In en, this message translates to:
  /// **'Measuring...'**
  String get measuring;

  /// Instruction text
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to start measuring'**
  String get tapToStart;

  /// Start button text
  ///
  /// In en, this message translates to:
  /// **'Start Measuring'**
  String get startMeasuring;

  /// Stop button text
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// Permission error message
  ///
  /// In en, this message translates to:
  /// **'Please allow microphone access to measure ambient sound level'**
  String get permissionDenied;

  /// Microphone error message
  ///
  /// In en, this message translates to:
  /// **'Unable to start microphone: {error}'**
  String micError(String error);

  /// Average decibel value
  ///
  /// In en, this message translates to:
  /// **'Average: {value} dB'**
  String average(String value);

  /// Percentile value
  ///
  /// In en, this message translates to:
  /// **'P{percentile}: {value} dB'**
  String percentile(int percentile, String value);

  /// Statistics section title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Minimum value
  ///
  /// In en, this message translates to:
  /// **'Min: {value} dB'**
  String min(String value);

  /// Status when initializing (3 second delay)
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// Info button tooltip
  ///
  /// In en, this message translates to:
  /// **'Measurement Information'**
  String get measurementInfo;

  /// Dialog title for measurement rules
  ///
  /// In en, this message translates to:
  /// **'Measurement Rules'**
  String get measurementRules;

  /// Content of measurement rules dialog
  ///
  /// In en, this message translates to:
  /// **'• Measurement starts 3 seconds after recording begins\n• This delay ensures accurate readings by allowing the microphone to stabilize\n• Statistics (min, average, percentiles) are calculated only after the initial 3-second period\n• Current decibel value is displayed in real-time throughout the measurement\n• For best results, keep the device steady during measurement'**
  String get measurementRulesContent;

  /// History page title
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Message when no history records
  ///
  /// In en, this message translates to:
  /// **'No history records'**
  String get noHistoryRecords;

  /// Delete record dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteRecord;

  /// Delete record confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record?'**
  String get deleteRecordConfirm;

  /// Delete all records action
  ///
  /// In en, this message translates to:
  /// **'Delete All Records'**
  String get deleteAllRecords;

  /// Delete all records confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all records? This action cannot be undone.'**
  String get deleteAllRecordsConfirm;

  /// Message when record is deleted
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get recordDeleted;

  /// Message when all records are deleted
  ///
  /// In en, this message translates to:
  /// **'All records deleted'**
  String get allRecordsDeleted;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'es',
    'hi',
    'ja',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
