import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import '../enums/blood_type.dart';
import '../enums/gender.dart';
import 'custom_text_field.dart';
import 'form_label.dart';

class PatientPhysicalInfoSection extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final String? selectedBloodType;
  final String? selectedGender;
  final Function(String?) onBloodTypeChanged;
  final Function(String?) onGenderChanged;

  const PatientPhysicalInfoSection({
    super.key,
    required this.heightController,
    required this.weightController,
    required this.selectedBloodType,
    required this.selectedGender,
    required this.onBloodTypeChanged,
    required this.onGenderChanged,
  });

  InputDecoration _buildDropdownDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Visina i Težina
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormLabel(text: l10n.height),
                  CustomTextField(
                    controller: heightController,
                    hintText: 'cm',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    suffixIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            final current =
                                int.tryParse(heightController.text) ?? 0;
                            heightController.text = '${current + 1}';
                          },
                          child: const Icon(
                            Icons.arrow_drop_up,
                            size: AppSpacing.md + 4,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final current =
                                int.tryParse(heightController.text) ?? 0;
                            if (current > 0) {
                              heightController.text = '${current - 1}';
                            }
                          },
                          child: const Icon(
                            Icons.arrow_drop_down,
                            size: AppSpacing.md + 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormLabel(text: l10n.weight),
                  CustomTextField(
                    controller: weightController,
                    hintText: 'kg',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    suffixIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            final current =
                                int.tryParse(weightController.text) ?? 0;
                            weightController.text = '${current + 1}';
                          },
                          child: const Icon(
                            Icons.arrow_drop_up,
                            size: AppSpacing.md + 4,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final current =
                                int.tryParse(weightController.text) ?? 0;
                            if (current > 0) {
                              weightController.text = '${current - 1}';
                            }
                          },
                          child: const Icon(
                            Icons.arrow_drop_down,
                            size: AppSpacing.md + 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Krvna grupa
        FormLabel(text: l10n.bloodType),
        DropdownButtonFormField<String>(
          value: selectedBloodType,
          decoration: _buildDropdownDecoration(l10n.selectBloodType),
          items: BloodType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type.value,
                  child: Text(type.value),
                ),
              )
              .toList(),
          onChanged: onBloodTypeChanged,
        ),
        const SizedBox(height: AppSpacing.md),

        // Pol
        FormLabel(text: l10n.gender),
        DropdownButtonFormField<String>(
          value: selectedGender,
          decoration: _buildDropdownDecoration(l10n.selectGender),
          items: [
            DropdownMenuItem(value: Gender.male.value, child: Text(l10n.male)),
            DropdownMenuItem(
              value: Gender.female.value,
              child: Text(l10n.female),
            ),
            DropdownMenuItem(
              value: Gender.other.value,
              child: Text(l10n.other),
            ),
          ],
          onChanged: onGenderChanged,
        ),
      ],
    );
  }
}
