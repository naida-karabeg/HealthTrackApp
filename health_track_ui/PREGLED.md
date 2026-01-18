# HealthTrack Flutter UI - Pregled projekta

## 📁 Struktura kreiranih fajlova

```
health_track_ui/
│
├── lib/
│   ├── main.dart                          # Entry point sa routing logikom
│   │
│   ├── models/                            # Data modeli
│   │   ├── user_model.dart               # Model korisnika sa role properties
│   │   ├── login_request.dart            # DTO za login zahtjev
│   │   └── register_request.dart         # DTO za registraciju
│   │
│   ├── providers/                         # State Management
│   │   └── auth_provider.dart            # AuthProvider sa login/register/logout
│   │
│   ├── services/                          # API Servisi
│   │   └── auth_service.dart             # HTTP pozivi ka backend API-ju
│   │
│   ├── utils/                             # Utility klase
│   │   └── api_constants.dart            # API URLs i headers
│   │
│   └── screens/                           # UI Ekrani
│       ├── auth/
│       │   ├── login_screen.dart         # Login forma
│       │   └── register_screen.dart      # Register forma sa role selection
│       ├── admin/
│       │   └── admin_home_screen.dart    # Admin dashboard
│       ├── doctor/
│       │   └── doctor_home_screen.dart   # Doctor portal
│       └── patient/
│           └── patient_home_screen.dart  # Patient profil
│
├── pubspec.yaml                           # Dependencies (provider, http, shared_preferences)
├── README.md                              # Detaljna dokumentacija
└── TESTIRANJE.md                          # Brzi vodič za testiranje
```

## 🎯 Implementirane funkcionalnosti

### ✅ Autentifikacija
- **Login** sa email i lozinkom
- **Registracija** sa različitim poljima prema ulozi (Patient, Doctor, Admin)
- **Token management** sa SharedPreferences
- **Auto-login** ako je token validan
- **Logout** funkcionalnost

### ✅ Role-Based Access Control
- **Admin**: Pristup desktop i mobile app - Admin Panel
- **Doctor**: Pristup desktop i mobile app - Doktor Portal  
- **Patient**: Pristup samo mobile app - Pacijent Profil

### ✅ State Management
- **Provider pattern** za globalno stanje
- **Loading states** tokom API poziva
- **Error handling** sa user-friendly porukama

### ✅ UI/UX
- Material Design 3
- Responsive layout
- Form validacija
- Password visibility toggle
- Date picker za datum rođenja
- Dropdown za pol, krvnu grupu i uloge

## 🔧 Backend integracija

### API Endpoints koji se koriste:
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Registracija

### Response format (AuthResponseDto):
```json
{
  "token": "JWT_TOKEN",
  "userId": "user-id",
  "email": "email@example.com",
  "firstName": "Ime",
  "lastName": "Prezime",
  "role": "Patient|Doctor|Admin",
  "expiresAt": "2026-01-16T..."
}
```

## 📱 Platforme

### ✅ Windows Desktop
- Potpuno funkcionalno
- Optimizirano za desktop prikaz
- Preporučeno za prvi test

### ✅ Android
- Support za emulator i fizičke uređaje
- Koristi `10.0.2.2` za localhost u emulatoru

### ✅ iOS  
- Support (nije testirano - potreban macOS)

## 🚀 Kako pokrenuti?

### 1. Backend
```bash
cd c:\Users\Korisnik\source\repos\API\HealthTrackApp
dotnet run
```

### 2. Flutter App (Desktop)
```bash
cd c:\Users\Korisnik\source\repos\API\health_track_ui
flutter run -d windows
```

## 🧪 Test Scenariji

### Test 1: Registracija novog Patient korisnika
1. Klikni "Registrujte se"
2. Izaberi Role: Patient
3. Popuni formu
4. Dodaj pol, krvnu grupu (opciono)
5. Registruj se
6. Vrati na login i prijavi se

### Test 2: Registracija Doctor korisnika
1. Registruj korisnika sa Role: Doctor
2. Dodaj specijalizaciju i odjel
3. Login
4. Trebao bi vidjeti Doctor Portal

### Test 3: Registracija Admin korisnika  
1. Registruj korisnika sa Role: Admin
2. Login
3. Trebao bi vidjeti Admin Panel

### Test 4: Token persistence
1. Prijavi se
2. Zatvori aplikaciju
3. Ponovo pokreni
4. Trebao bi ostati prijavljen (ako token nije istekao)

### Test 5: Logout
1. Na bilo kom home ekranu klikni logout ikonu
2. Trebao bi biti vraćen na login ekran

## 🔒 Sigurnost

- JWT tokens za autentifikaciju
- Password nije vidljiv tokom unosa (može se toggle-ovati)
- Token se čuva sigurno u SharedPreferences
- Automatsko provjera isteka tokena

## 📊 Sljedeći koraci za razvoj

1. **CRUD operacije**
   - Patient management
   - Doctor management  
   - Appointment scheduling

2. **Real-time features**
   - Notifications
   - Live health monitoring

3. **Additional screens**
   - Health Journal
   - Medication tracking
   - Appointment calendar

4. **UI improvements**
   - Dark mode
   - Lokalizacija
   - Better error handling

## 🐛 Poznati problemi i rješenja

### Problem: Connection refused
**Rješenje**: 
- Provjeri da li backend radi na `http://localhost:5183`
- Za Android emulator promijeni na `http://10.0.2.2:5183` u `api_constants.dart`

### Problem: ModelState validation errors
**Rješenje**: 
- Backend očekuje specifična polja prema ulozi
- Patient: gender, bloodType, emergencyContact
- Doctor: specialization, department

### Problem: Token expired
**Rješenje**:
- Token traje 24 sata (1440 minuta)
- Automatski se briše i vraća na login ekran

## 📞 Backend API Testiranje

Možeš testirati API direktno sa Swagger:
1. Otvori `http://localhost:5183/swagger`
2. Testiraj `/api/auth/register` endpoint
3. Testiraj `/api/auth/login` endpoint
4. Provjeri response format

## ✨ Gotovo!

Aplikacija je spremna za testiranje. Slijedi korake u `TESTIRANJE.md` fajlu za brzi start!
