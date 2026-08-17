import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

class CustomStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? patientsCount; 
  final Color? backgroundColor;
  final Color? contentColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const CustomStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.patientsCount, 
    this.backgroundColor,
    this.contentColor,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveBgColor = backgroundColor ?? theme.primaryColor.withOpacity(0.07);
    final effectiveContentColor = contentColor ?? theme.primaryColor;
    
    final isSpecialty = patientsCount != null;

    Widget cardContent = Container(
      width: isSpecialty ? context.widthPct(0.06) : null,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: boxShadow,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: AppSpacing.edgeInsets8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: effectiveContentColor, size: 26),
              
              SizedBox(height: context.heightPct(0.003)), 
  
              Text(
                title,
                style: theme.textTheme.headlineLarge?.copyWith(color: theme.primaryColor),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: context.heightPct(0.009)), 
              
             
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
    
                  color:  theme.colorScheme.primaryContainer.withOpacity(0.9),
                  fontWeight: isSpecialty ? FontWeight.bold : null,
                  fontSize: isSpecialty ? 12 : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              
              if (isSpecialty) ...[
                SizedBox(height: context.heightPct(0.005)),
                Text(
                  patientsCount!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  //  color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    
    return isSpecialty ? cardContent : Expanded(child: cardContent);
  }
}






















































































































/*class CustomStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? backgroundColor;
  final Color? contentColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const CustomStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.backgroundColor,
    this.contentColor,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // استخدام الألوان الممررة أو اعتماد ألوان افتراضية مأخوذة من الثيم لضمان المرونة
    final effectiveBgColor =
        backgroundColor ?? theme.primaryColor.withOpacity(0.07);
    final effectiveContentColor = contentColor ?? theme.primaryColor;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: boxShadow,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: AppSpacing.screenPadding5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: effectiveContentColor, size: 26),
                SizedBox(
                    height: context.heightPct(
                        0.0001)), 
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: effectiveContentColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                    height: context.heightPct(
                        0.0001)), // مسافة ديناميكية بناءً على ارتفاع الشاشة
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                   color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
/*class CustomStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? backgroundColor;
  final Color? contentColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const CustomStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.backgroundColor,
    this.contentColor,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveBgColor = backgroundColor ?? theme.primaryColor.withOpacity(0.07);
    final effectiveContentColor = contentColor ?? theme.primaryColor;

 
    return Container(
      width: context.widthPct(0.28),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: boxShadow,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: AppSpacing.screenPadding5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: effectiveContentColor, size: 26),
              
              SizedBox(height: context.heightPct(0.008)), 
              
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: effectiveContentColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: context.heightPct(0.004)),
              
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: effectiveContentColor.withOpacity(0.8), // جعل لون السعر متماشياً مع هوية لون القسم نفسه لراحة بصرية أعلى
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/












































































/*class CustomStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? backgroundColor;
  final Color? contentColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const CustomStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.backgroundColor,
    this.contentColor,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // استخدام الألوان الممررة أو اعتماد ألوان افتراضية مأخوذة من الثيم لضمان المرونة
    final effectiveBgColor =
        backgroundColor ?? theme.primaryColor.withOpacity(0.07);
    final effectiveContentColor = contentColor ?? theme.primaryColor;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: boxShadow,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: AppSpacing.screenPadding5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: effectiveContentColor, size: 26),
                SizedBox(
                    height: context.heightPct(
                        0.0001)), 
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: effectiveContentColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                    height: context.heightPct(
                        0.0001)), // مسافة ديناميكية بناءً على ارتفاع الشاشة
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                   color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
/*class CustomStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? backgroundColor;
  final Color? contentColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const CustomStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.backgroundColor,
    this.contentColor,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveBgColor = backgroundColor ?? theme.primaryColor.withOpacity(0.07);
    final effectiveContentColor = contentColor ?? theme.primaryColor;

 
    return Container(
      width: context.widthPct(0.28),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: boxShadow,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: AppSpacing.screenPadding5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: effectiveContentColor, size: 26),
              
              SizedBox(height: context.heightPct(0.008)), 
              
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: effectiveContentColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: context.heightPct(0.004)),
              
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: effectiveContentColor.withOpacity(0.8), // جعل لون السعر متماشياً مع هوية لون القسم نفسه لراحة بصرية أعلى
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/