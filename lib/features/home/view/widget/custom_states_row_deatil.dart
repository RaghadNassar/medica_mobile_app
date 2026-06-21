import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_state_card.dart';

class DoctorStatsRow extends StatelessWidget {
  final String patients;
  final String experience;
  final String rating;
  final VoidCallback onChatTap;

  const DoctorStatsRow({
    super.key,
    required this.patients,
    required this.experience,
    required this.rating,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardSpacing = SizedBox(width: context.widthPct(0.02)); 

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
       
        Flexible(
          child: CustomStatCard(
            icon: Icons.people_outline,
            title: patients,
            subtitle: StringManager.patients.tr,
          ),
        ),
        cardSpacing,

      
        Flexible(
          child: CustomStatCard(
            icon: Icons.star_border_rounded,
            title: rating,
            subtitle: StringManager.ratings.tr,
          ),
        ),
        cardSpacing,


        Flexible(
          child: CustomStatCard(
            icon: Icons.reviews_outlined,
            title: experience,
            subtitle: StringManager.reviews.tr,
          ),
        ),
      ],
    );
  }
}