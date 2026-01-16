# Lokalizacija - HealthTrack UI

## 🌍 Implementirana lokalizacija

Aplikacija sada podržava **dva jezika**:
- 🇧🇦 **Bosanski** (bs) - Default jezik
- 🇬🇧 **English** (en)

## ✨ Funkcionalnosti

### 1. Automatsko pamćenje jezika
- Odabrani jezik se čuva u SharedPreferences
- Aplikacija automatski učitava posljednji odabrani jezik pri pokretanju

### 2. Language Switcher na svim ekranima
- Ikona 🌐 u AppBar-u na svakom ekranu
- Dropdown meni sa checkmark za trenutni jezik
- Instant promjena jezika bez restarta aplikacije

### 3. Lokalizirani ekrani
- ✅ Login Screen
- ✅ Register Screen
- ✅ Admin Home Screen
- ✅ Doctor Home Screen
- ✅ Patient Home Screen

## 📁 Struktura fajlova

```
lib/
├── l10n/
│   ├── app_bs.arb                    # Bosanski prijevodi (JSON format)
│   ├── app_en.arb                    # Engleski prijevodi (JSON format)
│   ├── app_localizations.dart        # Abstract klasa i delegate
│   ├── app_localizations_bs.dart     # Bosanska implementacija
│   └── app_localizations_en.dart     # Engleska implementacija
├── providers/
│   └── locale_provider.dart          # State management za jezik
└── widgets/
    └── language_switcher.dart        # UI widget za promjenu jezika
```

## 🎯 Kako koristiti u kodu

### 1. Dobijanje lokalizacije u widgetu

```dart
import '../../l10n/app_localizations.dart';

@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  return Text(l10n.login); // Prikazaće "Prijavi se" ili "Login"
}
```

### 2. Validacija forme

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return l10n.emailRequired; // "Email je obavezan" ili "Email is required"
  }
  return null;
}
```

### 3. Snackbar poruke

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(l10n.registerSuccess)),
);
```

## 🔧 Dodavanje novog teksta

### 1. Dodaj u .arb fajlove

**app_bs.arb:**
```json
{
  "newKey": "Novi tekst na bosanskom"
}
```

**app_en.arb:**
```json
{
  "newKey": "New text in English"
}
```

### 2. Dodaj getter u AppLocalizations

**app_localizations.dart:**
```dart
abstract class AppLocalizations {
  String get newKey;
}
```

### 3. Implementiraj u oba jezika

**app_localizations_bs.dart:**
```dart
@override
String get newKey => 'Novi tekst na bosanskom';
```

**app_localizations_en.dart:**
```dart
@override
String get newKey => 'New text in English';
```

### 4. Koristi u kodu

```dart
Text(l10n.newKey)
```

## 🎨 Language Switcher Widget

### Automatsko korištenje

Widget je već dodan na sve ekrane:

```dart
AppBar(
  title: Text(l10n.myTitle),
  actions: [
    const LanguageSwitcher(),  // Automatski prikazuje language icon
    IconButton(...),
  ],
)
```

### Programatska promjena jezika

```dart
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

// U widgetu:
final localeProvider = Provider.of<LocaleProvider>(context);

// Postavi jezik
localeProvider.setLocale(const Locale('en'));

// Toggle između jezika
localeProvider.toggleLocale();
```

## 📝 Dostupni ključevi

### Opšti
- appTitle, login, register, logout
- email, password, confirmPassword
- firstName, lastName, phoneNumber, address, dateOfBirth
- role, userType

### Validacija
- emailRequired, emailInvalid
- passwordRequired, passwordMinLength
- confirmPasswordRequired, passwordsDoNotMatch
- firstNameRequired, lastNameRequired
- selectDateOfBirth

### Auth ekrani
- loginTitle, dontHaveAccount, alreadyHaveAccount
- registrationTitle, registerSuccess
- enterEmail, enterPassword

### Uloge
- patient, doctor, admin

### Patient polja
- gender, male, female, other
- bloodType, emergencyContact, emergencyContactOptional

### Doctor polja
- specialization, department
- phoneOptional, addressOptional

### Home ekrani
- adminPanel, doctorPortal, myProfile
- users, usersManagement
- doctors, doctorsManagement
- patients, patientsManagement
- settings, systemSettings

### Funkcionalnosti
- appointments, myAppointments, myPatients
- diagnoses, diagnosesReview
- therapies, therapiesManagement
- healthRecord, health
- quickAccess, recentActivity, noRecentActivity

### Ostalo
- comingSoon, unknownRole
- language, bosnian, english, changeLanguage

## 🧪 Testiranje lokalizacije

### 1. Pokreni aplikaciju
```bash
flutter run -d windows
```

### 2. Testiraj promjenu jezika
1. Klikni na 🌐 ikonu u gornjem desnom uglu
2. Izaberi "English"
3. Svi tekstovi se mijenjaju instant
4. Izaberi "Bosanski" da se vratiš

### 3. Testiraj persistentnost
1. Promijeni jezik na English
2. Zatvori aplikaciju
3. Ponovo pokreni - trebao bi ostati English

### 4. Testiraj na svim ekranima
- Login → Register → (Nakon login-a) Home
- Sve tri vrste Home ekrana (Admin, Doctor, Patient)
- Svi bi trebali imati language switcher

## 🚀 Best Practices

### ✅ Dobro
```dart
// Koristi lokalizovane stringove
Text(l10n.login)

// Kompozicija sa lokalizacijom
Text('${l10n.welcome}, ${user.name}')
```

### ❌ Loše
```dart
// Ne hardcode-uj tekstove
Text('Prijavi se')  // ❌

// Ne miješaj jezike
Text('Login na ${l10n.appTitle}')  // ❌
```

## 🔄 Dodavanje novog jezika

Ako želiš dodati npr. srpski jezik:

1. Kreiraj `app_sr.arb`
2. Kreiraj `app_localizations_sr.dart`
3. Dodaj u `supportedLocales`:
```dart
static const List<Locale> supportedLocales = <Locale>[
  Locale('bs'),
  Locale('en'),
  Locale('sr'),  // Novi jezik
];
```
4. Dodaj u `lookupAppLocalizations`:
```dart
case 'sr': return AppLocalizationsSr();
```
5. Ažuriraj LanguageSwitcher widget

## 📱 Platform specifičnosti

- **Desktop (Windows)**: Sve radi savršeno
- **Android**: Trebalo bi raditi bez problema
- **iOS**: Trebalo bi raditi bez problema

## 🐛 Troubleshooting

### Problem: "AppLocalizations.of(context) returned null"
**Rješenje**: Provjeri da li je MaterialApp.localizationsDelegates postavljen

### Problem: Jezik se ne mijenja
**Rješenje**: 
- Provjeri da li koristiš Consumer<LocaleProvider>
- Provjeri da li je LocaleProvider u Provider stablu

### Problem: Novi tekstovi ne rade
**Rješenje**:
- Obavezno dodaj getter u sve tri lokalizacione klase
- Restart aplikacije nakon promjena

## ✨ Gotovo!

Aplikacija sada ima potpunu podršku za više jezika sa mogućnošću instant prebacivanja na svakom ekranu! 🎉
