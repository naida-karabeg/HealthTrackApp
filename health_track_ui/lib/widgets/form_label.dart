import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FormLabel extends StatelessWidget {
  final String text;
  final bool required;

  const FormLabel({
    super.key,
    required this.text,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (required)
            Text(
              ' *',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                  ),
            ),
        ],
      ),
    );
  }
}
