import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

class NullDataWidget extends StatelessWidget {
  const NullDataWidget({
    super.key,
    required this.text,
    required this.imagePath,
    this.imageHeight,
    this.textColor,
  });

  final String text;
  final String imagePath;
  final double? imageHeight;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isSvg = imagePath.trim().toLowerCase().endsWith('.svg');

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding16_20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           isSvg
                ? SvgPicture.asset(
                    imagePath,
                    height: imageHeight ?? context.heightPct(0.4),
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryTeal.withOpacity(0.8),
                      BlendMode.srcIn,
                    ),
                  )
                : Image.asset(
                    imagePath,
                    height: imageHeight ?? context.heightPct(0.4),
                    fit: BoxFit.contain,
                  ),
            SizedBox(height: context.heightPct(0.02)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    textColor ?? theme.colorScheme.onSurface.withOpacity(0.6),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
