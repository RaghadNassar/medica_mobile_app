import 'package:flutter/material.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

/*
class BookingDateSelector extends StatelessWidget {
  final List<Map<String, String>> dates;
  final int selectedIndex;
  final Function(int) onDateSelected;

  const BookingDateSelector({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: context.heightPct(0.1),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onDateSelected(index),
            child: Container(
              width: context.widthPct(0.15),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? theme.primaryColor : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? theme.primaryColor : theme.colorScheme.primaryContainer.withOpacity(0.2)
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dates[index]['day']!,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected ? Colors.white : theme.colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dates[index]['date']!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}*/
class BookingDateSelector extends StatelessWidget {
  final List<Map<String, dynamic>> dates;
  final int selectedIndex;
  final Function(int) onDateSelected;

  const BookingDateSelector({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: context.heightPct(0.089),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final bool isSelected = index == selectedIndex;

          final bool isActive = dates[index]['isActive'] ?? true;

          return GestureDetector(
            onTap: isActive ? () => onDateSelected(index) : null,
            child: Container(
              width: context.widthPct(0.15),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: !isActive
                    ? theme.disabledColor.withOpacity(0.04)
                    : (isSelected
                        ? theme.primaryColor
                        : theme.colorScheme.surface),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? theme.primaryColor
                      : theme.colorScheme.primaryContainer
                          .withOpacity(isActive ? 0.2 : 0.05),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dates[index]['day']!,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: !isActive
                          ? theme.disabledColor.withOpacity(0.4)
                          : (isSelected
                              ? AppColors.lightSurface
                              : theme.colorScheme.primaryContainer),
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.009)),
                  Text(
                    dates[index]['date']!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: !isActive
                          ? theme.disabledColor.withOpacity(0.4)
                          : (isSelected
                              ? AppColors.lightSurface
                              : theme.colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
