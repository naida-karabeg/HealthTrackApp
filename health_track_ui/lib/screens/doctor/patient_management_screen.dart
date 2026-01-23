import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/doctor_navbar.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../../models/patient_model.dart';
import '../../services/patient_service.dart';

class PatientManagementScreen extends StatefulWidget {
  const PatientManagementScreen({Key? key}) : super(key: key);

  @override
  State<PatientManagementScreen> createState() =>
      _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  final _patientService = PatientService();
  final _searchController = TextEditingController();

  List<PatientModel> _allPatients = [];
  List<PatientModel> get _filteredPatients => _filterPatients();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _allPatients = await _patientService.getPatients();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<PatientModel> _filterPatients() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _allPatients;

    return _allPatients
        .where(
          (patient) =>
              patient.fullName.toLowerCase().contains(query) ||
              patient.email.toLowerCase().contains(query) ||
              (patient.phoneNumber?.contains(query) ?? false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: const DoctorNavBar(currentPage: 'patients'),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SearchBar(
              controller: _searchController,
              onSearch: () => setState(() {}),
              l10n: l10n,
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildBody(l10n)),
            const SizedBox(height: 24),
            _AddPatientButton(l10n: l10n, onRefresh: _loadPatients),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _ErrorView(
        message: _errorMessage!,
        onRetry: _loadPatients,
        l10n: l10n,
      );
    }

    if (_filteredPatients.isEmpty) {
      return Center(child: Text(l10n.noPatients));
    }

    return _PatientTable(
      patients: _filteredPatients,
      l10n: l10n,
      onRefresh: _loadPatients,
    );
  }
}

// Separated widgets for better organization
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final AppLocalizations l10n;

  const _SearchBar({
    required this.controller,
    required this.onSearch,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: l10n.searchByNameAndSurname,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
            onChanged: (_) => onSearch(),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: onSearch,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            l10n.search.toUpperCase(),
            style: const TextStyle(fontSize: AppSpacing.fontSizeMd, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color: AppColors.error)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}

class _PatientTable extends StatelessWidget {
  final List<PatientModel> patients;
  final AppLocalizations l10n;
  final VoidCallback onRefresh;

  const _PatientTable({
    required this.patients,
    required this.l10n,
    required this.onRefresh,
  });

  static const _columnWidths = {
    0: FlexColumnWidth(2.5),
    1: FlexColumnWidth(1.5),
    2: FlexColumnWidth(1.5),
    3: FlexColumnWidth(1.2),
    4: FlexColumnWidth(1.5),
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) => _PatientRow(
                patient: patients[index],
                l10n: l10n,
                onRefresh: onRefresh,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Table(
        columnWidths: _columnWidths,
        children: [
          TableRow(
            children: [
              l10n.nameAndSurname,
              l10n.dateOfBirth,
              l10n.contact,
              l10n.status,
              'Akcije',
            ].map((text) => _TableCell(text: text, isHeader: true)).toList(),
          ),
        ],
      ),
    );
  }
}

class _PatientRow extends StatelessWidget {
  final PatientModel patient;
  final AppLocalizations l10n;
  final VoidCallback onRefresh;

  const _PatientRow({
    required this.patient,
    required this.l10n,
    required this.onRefresh,
  });

  Future<void> _togglePatientStatus(
    BuildContext context,
    PatientModel patient,
    VoidCallback onRefresh,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmationMessage = patient.isActive 
        ? l10n.areYouSureDeactivate 
        : l10n.areYouSureActivate;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmation),
        content: Text('$confirmationMessage ${patient.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: patient.isActive ? AppColors.error : AppColors.success,
            ),
            child: Text(patient.isActive ? l10n.deactivate : l10n.activate),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final patientService = PatientService();
      await patientService.togglePatientStatus(patient);
      
      if (!context.mounted) return;
      
      final successMessage = !patient.isActive 
          ? l10n.patientDeactivatedSuccessfully 
          : l10n.patientActivatedSuccessfully;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: AppColors.success,
        ),
      );
      
      onRefresh();
    } catch (e) {
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Table(
        columnWidths: _PatientTable._columnWidths,
        children: [
          TableRow(
            children: [
              _TableCell(text: patient.fullName),
              _TableCell(
                text: DateFormat('dd.MM.yyyy').format(patient.dateOfBirth),
              ),
              _TableCell(text: patient.phoneNumber ?? '/'),
              _TableCell(
                text: patient.statusText,
                textColor: patient.isActive
                    ? AppColors.success
                    : AppColors.textSecondary,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _togglePatientStatus(context, patient, onRefresh),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          side: BorderSide(
                            color: patient.isActive ? AppColors.error : AppColors.success,
                          ),
                          foregroundColor: patient.isActive ? AppColors.error : AppColors.success,
                        ),
                        child: Text(
                          (patient.isActive ? l10n.deactivate : l10n.activate).toUpperCase(),
                          style: const TextStyle(fontSize: AppSpacing.fontSizeSm),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.of(context).pushNamed(
                            AppRoutes.doctorPatientDetails,
                            arguments: patient.id,
                          );
                          if (result == true) {
                            onRefresh();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          l10n.details.toUpperCase(),
                          style: const TextStyle(fontSize: AppSpacing.fontSizeSm),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final Color? textColor;

  const _TableCell({required this.text, this.isHeader = false, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(
          color: isHeader ? Colors.white : (textColor ?? AppColors.textPrimary),
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
          fontSize: AppSpacing.fontSizeMd,
        ),
      ),
    );
  }
}

class _AddPatientButton extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onRefresh;

  const _AddPatientButton({required this.l10n, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed(AppRoutes.doctorPatientsAdd);
          if (result == true) onRefresh();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        child: Text(
          l10n.addNewPatient.toUpperCase(),
          style: const TextStyle(fontSize: AppSpacing.fontSizeMd, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
