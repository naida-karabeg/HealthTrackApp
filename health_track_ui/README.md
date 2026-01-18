# HealthTrack UI - Flutter Aplikacija

Flutter aplikacija za HealthTrack sistem sa podrškom za desktop (Windows) i mobilne platforme (Android/iOS).

## Karakteristike

- **Multi-platforma**: Desktop (Windows), Android i iOS podrška
- **Role-based pristup**: Različiti ekrani za Admin, Doctor i Patient korisnike
- **Autentifikacija**: Integracija sa backend API-jem za login i registraciju
- **State Management**: Provider pattern za upravljanje stanjem
- **Persistent Storage**: SharedPreferences za čuvanje korisničkih podataka

## Tipovi korisnika i pristup

### Admin
- Pristup: Desktop i mobilna aplikacija
- Funkcionalnosti: Upravljanje korisnicima, doktorima, pacijentima i sistemskim postavkama

### Doctor (Doktor)
- Pristup: Desktop i mobilna aplikacija
- Funkcionalnosti: Pregled termina, upravljanje pacijentima, dijagnoze, terapije

### Patient (Pacijent)
- Pristup: Samo mobilna aplikacija
- Funkcionalnosti: Pregled zdravstvenog kartona, termini, terapije, zdravstveni parametri

## Preduvjeti

- Flutter SDK (3.10.7 ili noviji)
- Dart SDK
- Za Windows desktop: Visual Studio 2022 sa C++ Desktop Development workload
- Za Android: Android Studio sa Android SDK
- Backend API mora biti pokrenut (provjeri backend projekt u parent folderu)

## Instalacija

1. Instalacija dependencija:
```bash
flutter pub get
```

2. **VAŽNO**: Prije pokretanja aplikacije, konfiguriši API URL u `lib/utils/api_constants.dart`:

Za Desktop (Windows):
```dart
static const String baseUrl = 'http://localhost:5000';  // ili port gdje radi vaš API
```

Za Android Emulator:
```dart
static const String baseUrl = 'http://10.0.2.2:5000';
```

Za iOS Simulator:
```dart
static const String baseUrl = 'http://localhost:5000';
```

Za stvarni mobilni uređaj:
```dart
static const String baseUrl = 'http://192.168.x.x:5000';  // IP adresa vašeg računara
```

## Pokretanje aplikacije

### Windows Desktop
```bash
flutter run -d windows
```

### Android Emulator
```bash
flutter run -d android
```

### iOS Simulator (samo na macOS)
```bash
flutter run -d ios
```

### Odabir uređaja
Prikaz svih dostupnih uređaja:
```bash
flutter devices
```

## Struktura projekta

```
lib/
├── models/              # Data modeli
│   ├── user_model.dart
│   ├── login_request.dart
│   └── register_request.dart
├── providers/           # State management (Provider)
│   └── auth_provider.dart
├── screens/             # UI ekrani
│   ├── auth/           # Login i Register ekrani
│   ├── admin/          # Admin dashboard
│   ├── doctor/         # Doctor portal
│   └── patient/        # Patient profil
├── services/            # API servisi
│   └── auth_service.dart
├── utils/              # Utility klase
│   └── api_constants.dart
└── main.dart           # Entry point i routing
```

## Testiranje autentifikacije

### Registracija novog korisnika

1. Pokreni aplikaciju
2. Klikni na "Registrujte se"
3. Popuni formu:
   - Izaberi tip korisnika (Patient, Doctor, Admin)
   - Unesi lične podatke
   - Za Patient: dodaj pol, krvnu grupu, hitni kontakt
   - Za Doctor: dodaj specijalizaciju i odjel
4. Klikni "Registruj se"

### Login

1. Unesi email i lozinku
2. Klikni "Prijavi se"
3. Automatski ćeš biti preusmjeren na odgovarajući dashboard prema ulozi

### Role-based routing

- **Admin korisnik** → Admin Panel (desktop i mobile)
- **Doctor korisnik** → Doktor Portal (desktop i mobile)
- **Patient korisnik** → Pacijent Profil (samo mobile)

## Backend konfiguracija

Prije testiranja, osiguraj da backend API radi:

1. Pokreni backend projekat (API projekat)
2. Provjeri da li API radi na `http://localhost:PORT`
3. Provjeri da li AuthController ima endpoint-e:
   - `POST /api/auth/login`
   - `POST /api/auth/register`

## Troubleshooting

### Greška "Greška pri povezivanju sa serverom"
- Provjeri da li je backend pokrenut
- Provjeri URL u `api_constants.dart`
- Za Android emulator koristi `10.0.2.2` umjesto `localhost`

### Token validation greška
- Token se automatski čuva u SharedPreferences
- Provjeri `expiresAt` datum u backend responsu

### Build greške
```bash
flutter clean
flutter pub get
flutter run
```

## Sljedeći koraci

Nakon testiranja login/register funkcionalnosti, možeš dodati:
- CRUD operacije za pacijente
- Appointment sistem
- Health journal funkcionalnosti
- Notifications
- Real-time ažuriranja

## Resursi

- [Flutter dokumentacija](https://docs.flutter.dev/)
- [Provider package](https://pub.dev/packages/provider)
- [HTTP package](https://pub.dev/packages/http)
