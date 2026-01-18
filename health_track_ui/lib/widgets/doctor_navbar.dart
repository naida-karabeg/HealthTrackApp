import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_routes.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'language_switcher.dart';

class DoctorNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  
  static const double _navBarHeight = 70.0;
  static const double _horizontalPadding = 24.0;
  static const double _verticalPadding = 12.0;
  static const double _navItemSpacing = 32.0;

  const DoctorNavBar({
    Key? key,
    required this.currentPage,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(_navBarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
          child: Row(
            children: [
              // Logo
              Row(
                children: [
                  const Icon(
                    Icons.health_and_safety,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'HEALTHTRACK',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 48),
              
              // Navigation Items
              Expanded(
                child: Row(
                  children: [
                    _NavItem(
                      title: l10n.home,
                      isActive: currentPage == 'home',
                      onTap: () => _navigateTo(context, 'home'),
                    ),
                    const SizedBox(width: _navItemSpacing),
                    _NavItem(
                      title: l10n.patientsManagement,
                      isActive: currentPage == 'patients',
                      onTap: () => _navigateTo(context, 'patients'),
                    ),
                    const SizedBox(width: _navItemSpacing),
                    _NavItem(
                      title: l10n.appointments,
                      isActive: currentPage == 'appointments',
                      onTap: () => _navigateTo(context, 'appointments'),
                    ),
                    const SizedBox(width: _navItemSpacing),
                    _NavItem(
                      title: l10n.reports,
                      isActive: currentPage == 'reports',
                      onTap: () => _navigateTo(context, 'reports'),
                    ),
                    const SizedBox(width: _navItemSpacing),
                    _NavItem(
                      title: l10n.settings,
                      isActive: currentPage == 'settings',
                      onTap: () => _navigateTo(context, 'settings'),
                    ),
                  ],
                ),
              ),
              
              // Right side icons
              const SizedBox(width: 24),
              const LanguageSwitcher(),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.textSecondary,
                onPressed: () {
                  // TODO: Navigate to notifications
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.account_circle_outlined),
                color: AppColors.textSecondary,
                iconSize: 28,
                onPressed: () {
                  _showProfileMenu(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);
    
    showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 200,
        70,
        20,
        0,
      ),
      items: <PopupMenuEntry<void>>[
        PopupMenuItem<void>(
          child: Row(
            children: [
              const Icon(Icons.person, size: 20),
              const SizedBox(width: 8),
              Text(l10n.myProfile),
            ],
          ),
          onTap: () {
            // TODO: Navigate to profile
          },
        ),
        PopupMenuItem<void>(
          child: Row(
            children: [
              const Icon(Icons.settings, size: 20),
              const SizedBox(width: 8),
              Text(l10n.settings),
            ],
          ),
          onTap: () {
            _navigateTo(context, 'settings');
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          child: Row(
            children: [
              const Icon(Icons.logout, size: 20, color: AppColors.error),
              const SizedBox(width: 8),
              Text(l10n.logout, style: const TextStyle(color: AppColors.error)),
            ],
          ),
          onTap: () {
            // Zatvori menu prvo, pa onda logout
            Future.microtask(() => authProvider.logout());
          },
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, String page) {
    if (page == currentPage) return;
    
    final routes = {
      'home': AppRoutes.doctorHome,
      'patients': AppRoutes.doctorPatients,
      'appointments': AppRoutes.doctorAppointments,
      'reports': AppRoutes.doctorReports,
      'settings': AppRoutes.doctorSettings,
    };
    
    final routeName = routes[page];
    if (routeName != null) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    Key? key,
    required this.title,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
