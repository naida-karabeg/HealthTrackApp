import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context);
    
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: l10n.changeLanguage,
      onSelected: (Locale locale) {
        localeProvider.setLocale(locale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: const Locale('bs'),
          child: Row(
            children: [
              if (localeProvider.locale.languageCode == 'bs')
                const Icon(Icons.check, size: 20),
              if (localeProvider.locale.languageCode == 'bs')
                const SizedBox(width: 8),
              Text(l10n.bosnian),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            children: [
              if (localeProvider.locale.languageCode == 'en')
                const Icon(Icons.check, size: 20),
              if (localeProvider.locale.languageCode == 'en')
                const SizedBox(width: 8),
              Text(l10n.english),
            ],
          ),
        ),
      ],
    );
  }
}
