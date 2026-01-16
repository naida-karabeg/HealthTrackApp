import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bs.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('bs'),
    Locale('en')
  ];

  String get appTitle;
  String get login;
  String get register;
  String get logout;
  String get email;
  String get password;
  String get confirmPassword;
  String get firstName;
  String get lastName;
  String get phoneNumber;
  String get address;
  String get dateOfBirth;
  String get selectDate;
  String get role;
  String get userType;
  
  String get emailRequired;
  String get emailInvalid;
  String get passwordRequired;
  String get passwordMinLength;
  String get confirmPasswordRequired;
  String get passwordsDoNotMatch;
  String get firstNameRequired;
  String get lastNameRequired;
  String get selectDateOfBirth;
  
  String get loginTitle;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get registrationTitle;
  String get registerSuccess;
  String get enterEmail;
  String get enterPassword;
  
  String get patient;
  String get doctor;
  String get admin;
  
  String get gender;
  String get male;
  String get female;
  String get other;
  
  String get bloodType;
  String get emergencyContact;
  String get emergencyContactOptional;
  
  String get specialization;
  String get department;
  String get phoneOptional;
  String get addressOptional;
  
  String get adminPanel;
  String get doctorPortal;
  String get myProfile;
  
  String get users;
  String get usersManagement;
  String get doctors;
  String get doctorsManagement;
  String get patients;
  String get patientsManagement;
  String get settings;
  String get systemSettings;
  
  String get appointments;
  String get myAppointments;
  String get myPatients;
  String get diagnoses;
  String get diagnosesReview;
  String get therapies;
  String get therapiesManagement;
  
  String get healthRecord;
  String get health;
  String get quickAccess;
  String get recentActivity;
  String get noRecentActivity;
  
  String get comingSoon;
  String get unknownRole;
  
  String get language;
  String get bosnian;
  String get english;
  String get changeLanguage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'bs': return AppLocalizationsBs();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
