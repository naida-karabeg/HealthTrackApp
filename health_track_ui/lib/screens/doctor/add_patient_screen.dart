import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/patient_insert_request.dart';
import '../../services/patient_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/breadcrumb_helpers.dart';
import '../../widgets/breadcrumb.dart';
import '../../widgets/doctor_navbar.dart';
import '../../widgets/patient_basic_info_section.dart';
import '../../widgets/patient_contact_section.dart';
import '../../widgets/patient_physical_info_section.dart';
import '../../widgets/patient_medical_info_section.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientService = PatientService();

  // Controllers
  final _firstNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _therapyController = TextEditingController();

  DateTime? _selectedDateOfBirth;
  DateTime? _selectedNextAppointment;
  String? _selectedBloodType;
  String? _selectedGender;
  bool _isActive = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _medicalHistoryController.dispose();
    _therapyController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime) onDateSelected,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        onDateSelected(picked);
      });
    }
  }

  Future<void> _savePatient() async {
    // Prvo provjerimo datum rođenja
    if (_selectedDateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectDateOfBirth),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Zatim provjerimo ostala polja forme
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Generišemo username iz email-a (dio prije @)
      final userName = _emailController.text.split('@').first;

      final request = PatientInsertRequest(
        firstName: _firstNameController.text.trim(),
        lastName: '',
        dateOfBirth: _selectedDateOfBirth!,
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        gender: _selectedGender ?? 'O',
        emergencyContact: _phoneController.text.trim(),
        bloodType: _selectedBloodType,
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        userName: userName,
        isActive: true,
      );

      await _patientService.createPatient(request);

      if (!mounted) return;

      // Uspješno sačuvan, vrati se na patient management
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.patientAddedSuccessfully),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const DoctorNavBar(currentPage: 'patientManagement'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumb
                  Breadcrumb(items: BreadcrumbHelpers.forNewPatient(context)),
                  const SizedBox(height: AppSpacing.lg),

                  // Forma
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Basic Info Section
                          PatientBasicInfoSection(
                            firstNameController: _firstNameController,
                            selectedDateOfBirth: _selectedDateOfBirth,
                            onSelectDate:
                                ({
                                  required context,
                                  required initialDate,
                                  required firstDate,
                                  required lastDate,
                                  required onDateSelected,
                                }) async {
                                  await _selectDate(
                                    context: context,
                                    initialDate: initialDate,
                                    firstDate: firstDate,
                                    lastDate: lastDate,
                                    onDateSelected: (date) {
                                      _selectedDateOfBirth = date;
                                      onDateSelected(date);
                                    },
                                  );
                                },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Contact Section
                          PatientContactSection(
                            phoneController: _phoneController,
                            emailController: _emailController,
                            addressController: _addressController,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Physical Info Section
                          PatientPhysicalInfoSection(
                            heightController: _heightController,
                            weightController: _weightController,
                            selectedBloodType: _selectedBloodType,
                            selectedGender: _selectedGender,
                            onBloodTypeChanged: (value) {
                              setState(() {
                                _selectedBloodType = value;
                              });
                            },
                            onGenderChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Medical Info Section
                          PatientMedicalInfoSection(
                            medicalHistoryController: _medicalHistoryController,
                            therapyController: _therapyController,
                            selectedNextAppointment: _selectedNextAppointment,
                            onSelectDate:
                                ({
                                  required context,
                                  required initialDate,
                                  required firstDate,
                                  required lastDate,
                                  required onDateSelected,
                                }) async {
                                  await _selectDate(
                                    context: context,
                                    initialDate: initialDate,
                                    firstDate: firstDate,
                                    lastDate: lastDate,
                                    onDateSelected: (date) {
                                      _selectedNextAppointment = date;
                                      onDateSelected(date);
                                    },
                                  );
                                },
                            onAppointmentsPressed: () {
                              // Otvori listu termina
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Aktivan checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _isActive,
                                onChanged: (value) {
                                  setState(() {
                                    _isActive = value ?? true;
                                  });
                                },
                                activeColor: AppColors.primary,
                              ),
                              Text(
                                l10n.active,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Error message
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: Text(
                                _errorMessage!,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.error),
                              ),
                            ),

                          // Sačuvaj dugme
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _savePatient,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd,
                                  ),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: AppColors.textOnPrimary,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      l10n.save.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.textOnPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
