
import 'package:flutter/material.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/profile/presentation/widget/profile_header_widget.dart';

class ProfileBackgroundHeader extends StatelessWidget {
  const ProfileBackgroundHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          height: context.heightPct(0.22),
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
        ),
        const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ProfileHeader(),
          ),
        ),
      ],
    );
  }
}