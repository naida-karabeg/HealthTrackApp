import '../l10n/app_localizations.dart';

class FormValidators {
  FormValidators._();

  static String? required(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.emailRequired;
    }
    if (!value.contains('@')) {
      return l10n.emailInvalid;
    }
    return null;
  }

  static String? phone(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }
}
