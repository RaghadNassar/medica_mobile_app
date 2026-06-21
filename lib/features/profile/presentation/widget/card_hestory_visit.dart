// lib/features/profile/presentation/widgets/medical_visit_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/profile/data/model/hestory_medical.dart';
import 'package:raghad_pro/main.dart';

class MedicalVisitCard extends StatelessWidget {
  final MedicalRecordModel record;
  final String formattedDate;

  const MedicalVisitCard({
    super.key,
    required this.record,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCheck = record.visitType == 'check';
    final Color sideColor = isCheck ?AppColors.info : AppColors.warning;
    final String typeLabel = isCheck ?  StringManager.check.tr: StringManager.review.tr;

    return Container(
      margin:AppSpacing.bottom16,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: sideColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:AppSpacing.edgeInsets16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " ${record.doctorName}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold,fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: sideColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(color: sideColor, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: context.heightPct(0.01)),
                    Text(
                      "${record.specialization} • ${record.clinic}",
                      style:Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)
                    ),
                    SizedBox(height: context.heightPct(0.01)),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        record.diagnosis,
                        style:Theme.of(context).textTheme.bodyMedium
                    ),
                      ),
                    
                    SizedBox(height: context.heightPct(0.01)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formattedDate,
                        style:Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}