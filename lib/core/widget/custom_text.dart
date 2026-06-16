import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';

class CustomText extends StatelessWidget {
  const CustomText( {super.key, required this.title, required this.style});
  final String title;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding8,
      child: Text(
        title,
        style: style,
      ),
    );
  }
}