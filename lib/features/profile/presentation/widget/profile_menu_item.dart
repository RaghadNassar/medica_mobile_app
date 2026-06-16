import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: AppSpacing.edgeInsets8,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.04),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(title, style:Theme.of(context).textTheme.bodyLarge!),
      trailing:  Icon(Icons.arrow_forward_ios, size: 18, color: Theme.of(context).colorScheme.primaryContainer,),
      contentPadding: AppSpacing.vertical10,
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? trailingText; // 👈 إضافة متغير اختياري لنص اللغة

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText, // 👈 ليس إجبارياً، في البروفايل لن نمرره
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: AppSpacing.edgeInsets8,
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.04),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: theme.primaryColor),
      ),
      title: Text(title, style: theme.textTheme.bodyLarge!),
      
      // 👈 تعديل الـ trailing بذكاء ليدعم النص والسهم معاً إذا وُجد النص
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText!,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(width: 8),
          ],
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: theme.colorScheme.primaryContainer,
          ),
        ],
      ),
      contentPadding: AppSpacing.vertical10,
    );
  }
}*/