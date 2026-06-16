import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';

class BaseSubSettingsScreen extends StatelessWidget {
  final String title;
  final Widget content;

  const BaseSubSettingsScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          title,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.screenPadding9,
        child: content,
      ),
    );
  }
}
