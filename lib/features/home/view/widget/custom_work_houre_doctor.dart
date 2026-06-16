import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';

class DoctorWorkingHours extends StatelessWidget {
  final Map<String, String> workingHours;

  const DoctorWorkingHours({super.key, required this.workingHours});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: workingHours.entries.map((entry) {
        return Padding(
          padding: AppSpacing.vertical6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.key,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurface)),
              Text(entry.value,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.primaryContainer)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
