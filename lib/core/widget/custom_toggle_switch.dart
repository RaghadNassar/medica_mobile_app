import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

class CustomToggleSwitch extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onSelect;

  const CustomToggleSwitch({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.heightPct(0.067), // الارتفاع المثالي كما في الصورة
      padding: AppSpacing.screenPadding9,
      decoration: BoxDecoration(
        color:Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.49), // لون الخلفية الفاتح جداً من الفيغما
        borderRadius: BorderRadius.circular(20), // زوايا دائرية كاملة
        border: Border.all(color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5), width: 0.5), // حدود خفيفة
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          bool isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  // اللون الأبيض للزر المختار مع ظل خفيف
                  color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.88) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      // لون التيل (Teal) للمختار والرمادي لغير المختار
                      color: isSelected ? AppColors.lightSurface : Theme.of(context).colorScheme.primary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}