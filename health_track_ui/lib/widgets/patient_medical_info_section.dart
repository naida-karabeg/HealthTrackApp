import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import 'custom_text_field.dart';
import 'form_label.dart';

class PatientMedicalInfoSection extends StatelessWidget {
  final TextEditingController medicalHistoryController;
  final TextEditingController therapyController;
  final DateTime? selectedNextAppointment;
  final Function({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime) onDateSelected,
  }) onSelectDate;
  final VoidCallback onAppointmentsPressed;

  const PatientMedicalInfoSection({
    super.key,
    required this.medicalHistoryController,
    required this.therapyController,
    required this.selectedNextAppointment,
    required this.onSelectDate,
    required this.onAppointmentsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Medicinska historija
        FormLabel(text: l10n.medicalHistory),
        CustomTextField(
          controller: medicalHistoryController,
          hintText: l10n.enterDiagnosis,
          maxLines: 3,
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: TextButton.icon(
            onPressed: () {
              // Dodaj novu dijagnozu
            },
            icon: const Icon(Icons.add),
            label: const Text('+'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Terapije
        FormLabel(text: l10n.therapies),
        CustomTextField(
          controller: therapyController,
          hintText: l10n.enterTherapy,
          maxLines: 3,
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: TextButton.icon(
            onPressed: () {
              // Dodaj novu terapiju
            },
            icon: const Icon(Icons.add),
            label: const Text('+'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Naredni zakazan termin
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormLabel(text: l10n.nextAppointment),
                  InkWell(
                    onTap: () => onSelectDate(
                      context: context,
                      initialDate: selectedNextAppointment ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      onDateSelected: (date) {
                        // Date is handled in parent widget
                      },
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedNextAppointment != null
                                ? DateFormat('dd/MM/yyyy').format(selectedNextAppointment!)
                                : '21/11/2024',
                            style: TextStyle(
                              color: selectedNextAppointment != null
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                            size: AppSpacing.md + 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton(
              onPressed: onAppointmentsPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: Text(
                l10n.appointments.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: AppSpacing.md,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
