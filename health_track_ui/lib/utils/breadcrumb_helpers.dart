import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/breadcrumb.dart';

class BreadcrumbHelpers {
  /// Breadcrumb za dodavanje novog pacijenta
  static List<BreadcrumbItem> forNewPatient(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      BreadcrumbItem(
        label: l10n.patientsManagement,
        onTap: () => Navigator.of(context).pop(),
      ),
      BreadcrumbItem(
        label: l10n.newPatient,
      ),
    ];
  }

  /// Breadcrumb za detalje pacijenta
  static List<BreadcrumbItem> forPatientDetails(
    BuildContext context,
    String patientName,
  ) {
    final l10n = AppLocalizations.of(context);
    return [
      BreadcrumbItem(
        label: l10n.patientsManagement,
        onTap: () => Navigator.of(context).pop(),
      ),
      BreadcrumbItem(
        label: patientName,
      ),
    ];
  }

  /// Breadcrumb za uređivanje pacijenta
  static List<BreadcrumbItem> forEditPatient(
    BuildContext context,
    String patientName,
  ) {
    final l10n = AppLocalizations.of(context);
    return [
      BreadcrumbItem(
        label: l10n.patientsManagement,
        onTap: () => Navigator.of(context).popUntil(
          (route) => route.settings.name == '/patient-management' || route.isFirst,
        ),
      ),
      BreadcrumbItem(
        label: patientName,
        onTap: () => Navigator.of(context).pop(),
      ),
      BreadcrumbItem(
        label: 'Edit', // Dodaj u lokalizaciju kasnije
      ),
    ];
  }
}
