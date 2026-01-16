# BRZI VODIČ ZA TESTIRANJE

## Korak 1: Pokreni Backend API

```bash
cd c:\Users\Korisnik\source\repos\API\HealthTrackApp
dotnet run
```

Backend bi trebao biti dostupan na: `http://localhost:5183`

Provjeri da li vidiš Swagger na: `http://localhost:5183/swagger`

## Korak 2: Pokreni Flutter aplikaciju

### Za Windows Desktop (preporučeno za prvi test):
```bash
cd c:\Users\Korisnik\source\repos\API\health_track_ui
flutter run -d windows
```

### Za Android Emulator:
**VAŽNO**: Prvo promijeni API URL u `lib/utils/api_constants.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:5183';
```

Zatim pokreni:
```bash
flutter run -d android
```

## Korak 3: Testiraj Registraciju

1. Klikni "Registrujte se"
2. Popuni podatke:
   - **Email**: test@example.com
   - **Password**: Test123!
   - **Ime**: Test
   - **Prezime**: User
   - **Datum rođenja**: Izaberi bilo koji datum
   - **Tip korisnika**: Patient (ili Doctor/Admin)
   
3. Za Patient dodaj (opciono):
   - Pol
   - Krvna grupa
   - Telefon

4. Klikni "Registruj se"

## Korak 4: Testiraj Login

Nakon uspješne registracije, bit ćeš vraćen na login ekran.

1. Unesi email i lozinku
2. Klikni "Prijavi se"
3. Trebao bi biti preusmjeren na:
   - Admin Panel (ako si Admin)
   - Doktor Portal (ako si Doctor)
   - Moj Profil (ako si Patient)

## Korak 5: Testiraj različite uloge

Registruj dodatne korisnike sa različitim ulogama da vidiš različite dashboardove:

### Admin korisnik
- Email: admin@test.com
- Role: Admin
- Vidiš: Admin Panel sa upravljanjem korisnicima

### Doctor korisnik
- Email: doctor@test.com
- Role: Doctor
- Vidiš: Doktor Portal sa terminima i pacijentima

### Patient korisnik
- Email: patient@test.com
- Role: Patient
- Vidiš: Pacijent Profil sa zdravstvenim kartonom

## Provjera tokena

Token se automatski čuva i aplikacija će te održati prijavljenim čak i nakon zatvaranja aplikacije (dok token ne istekne).

## Troubleshooting

### Backend se ne može pokrenuti?
```bash
cd c:\Users\Korisnik\source\repos\API\HealthTrackApp
dotnet ef database update
dotnet run
```

### Flutter build greška?
```bash
flutter clean
flutter pub get
flutter run -d windows
```

### Connection refused greška?
- Provjeri da li backend radi
- Provjeri URL u `lib/utils/api_constants.dart`
- Za Android emulator koristi `10.0.2.2:5183`

### Token validation error?
- Provjeri `JwtSettings` u `appsettings.json`
- Token traje 1440 minuta (24 sata) po defaultu
