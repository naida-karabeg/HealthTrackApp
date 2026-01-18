import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/doctor/doctor_home_screen.dart';
import 'screens/doctor/patient_management_screen.dart';
import 'screens/patient/patient_home_screen.dart';
import 'l10n/app_localizations.dart';
import 'utils/app_theme.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'HealthTrack',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            home: const AuthWrapper(),
            routes: {
              AppRoutes.login: (context) => const LoginScreen(),
              AppRoutes.register: (context) => const RegisterScreen(),
              AppRoutes.adminHome: (context) => const AdminHomeScreen(),
              AppRoutes.doctorHome: (context) => const DoctorHomeScreen(),
              AppRoutes.doctorPatients: (context) => const PatientManagementScreen(),
              AppRoutes.patientHome: (context) => const PatientHomeScreen(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Ako korisnik nije prijavljen, prikaži login ekran
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        // Ako je prijavljen, preusmjeri ga na odgovarajući home screen prema ulozi
        final user = authProvider.currentUser!;
        
        if (user.isAdmin) {
          return const AdminHomeScreen();
        } else if (user.isDoctor) {
          return const DoctorHomeScreen();
        } else if (user.isPatient) {
          return const PatientHomeScreen();
        } else {
          // Fallback u slučaju nepoznate uloge
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nepoznata uloga korisnika'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => authProvider.logout(),
                    child: const Text('Odjavi se'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
