import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import '../utils/form_validators.dart';
import 'custom_text_field.dart';
import 'form_label.dart';

class PatientContactSection extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;

  const PatientContactSection({
    super.key,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kontakt
        FormLabel(text: l10n.contact, required: true),
        
        CustomTextField(
          controller: phoneController,
          hintText: l10n.enterPhoneNumber,
          keyboardType: TextInputType.phone,
          validator: (value) => FormValidators.phone(value, l10n.phoneRequired),
        ),
        const SizedBox(height: AppSpacing.md),

        // Adresa
        FormLabel(text: l10n.address),
        CustomTextField(
          controller: addressController,
          hintText: l10n.addressOptional,
        ),
           const SizedBox(height: AppSpacing.md),

        // Email
        FormLabel(text: l10n.email, required: true),
        CustomTextField(
          controller: emailController,
          hintText: 'example@edu.fit.ba',
          keyboardType: TextInputType.emailAddress,
          validator: (value) => FormValidators.email(value, l10n),
        ),
      ],
    );
  }
}
