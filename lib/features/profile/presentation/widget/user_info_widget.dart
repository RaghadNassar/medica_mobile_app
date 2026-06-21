
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/auth/controler/auth_logic.dart';
import 'package:raghad_pro/features/profile/controller/profile_controller.dart';
/*
class UserInformation extends StatelessWidget {
  final ThemeData theme;
  const UserInformation({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Raghad Nassar',
          style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold, // جعل الاسم عريضاً وواضحاً
          color:theme.colorScheme.surface, // لون داكن قريب للأسود
        ),
        ),
         SizedBox(height: context.heightPct(0.01)),
        Text(
          'albert.florest@email.com',
          style: theme.textTheme.bodyMedium?.copyWith(
          color:theme.colorScheme.surface.withOpacity(0.8), // لون رمادي لتقليل الوزن البصري
          letterSpacing: 0.5,
        ),
        ),
      ],
    );
  }
}*/
class UserInformation extends GetView<ProfileController> {
  final ThemeData theme;
  final String name;
  final String email;

  const UserInformation({
    super.key, 
    required this.theme, 
    required this.name, 
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name.isNotEmpty ? name : 'Loading...',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.surface,
          ),
        ),
        SizedBox(height: context.heightPct(0.0001)),
        Text(
          email.isNotEmpty ? email : 'Loading...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.surface.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}