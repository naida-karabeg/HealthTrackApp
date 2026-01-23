import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import '../utils/form_validators.dart';
import 'custom_text_field.dart';
import 'form_label.dart';

class PatientBasicInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final DateTime? selectedDateOfBirth;
  final Function({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime) onDateSelected,
  }) onSelectDate;

  const PatientBasicInfoSection({
    super.key,
    required this.firstNameController,
    required this.selectedDateOfBirth,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ime i prezime
        FormLabel(text: l10n.nameAndSurname, required: true),
        CustomTextField(
          controller: firstNameController,
          hintText: l10n.enterFullName,
          validator: (value) => FormValidators.required(value, l10n.firstNameRequired),
        ),
        const SizedBox(height: AppSpacing.md),

        // Datum rođenja
        FormLabel(text: l10n.dateOfBirth, required: true),
        InkWell(
          onTap: () => onSelectDate(
            context: context,
            initialDate: selectedDateOfBirth ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
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
                  selectedDateOfBirth != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDateOfBirth!)
                      : '21/10/2002',
                  style: TextStyle(
                    color: selectedDateOfBirth != null
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
    );
  }
}
