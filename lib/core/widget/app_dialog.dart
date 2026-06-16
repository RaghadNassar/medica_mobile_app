import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

class CustomAppDialog extends StatelessWidget {
  final Widget topWidget;     
  final String title;         
  final List<Widget> buttons;  

  const CustomAppDialog({
    super.key,
    required this.topWidget,
    required this.title,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: theme.colorScheme.surface,
      child: Padding(
        padding: AppSpacing.screenPadding24_16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            topWidget,
             SizedBox(height: context.heightPct(0.02)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
             SizedBox(height: context.heightPct(0.03)),
            
           
            ...buttons.map((button) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: button,
                )),
          ],
        ),
      ),
    );
  }
}


class DialogActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? borderColor;
  final Color? textColor;

  const DialogActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: AppSpacing.vertical16,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? theme.primaryColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor ?? theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}