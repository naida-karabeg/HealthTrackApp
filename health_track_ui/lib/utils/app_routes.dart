class AppRoutes {
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  
  // Admin routes
  static const String adminHome = '/admin-home';
  static const String adminUsers = '/admin-users';
  static const String adminDoctors = '/admin-doctors';
  static const String adminPatients = '/admin-patients';
  static const String adminSettings = '/admin-settings';
  
  // Doctor routes
  static const String doctorHome = '/doctor-home';
  static const String doctorPatients = '/doctor-patients';
  static const String doctorAppointments = '/doctor-appointments';
  static const String doctorReports = '/doctor-reports';
  static const String doctorSettings = '/doctor-settings';
  
  // Patient routes
  static const String patientHome = '/patient-home';
  static const String patientAppointments = '/patient-appointments';
  static const String patientHealthRecord = '/patient-health-record';
  static const String patientTherapies = '/patient-therapies';
  static const String patientSettings = '/patient-settings';
}
