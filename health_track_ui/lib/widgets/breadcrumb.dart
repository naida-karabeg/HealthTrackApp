import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const Breadcrumb({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '>>',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
          items[i].onTap != null
              ? InkWell(
                  onTap: items[i].onTap,
                  child: Text(
                    items[i].label,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
                  items[i].label,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],
      ],
    );
  }
}

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}
