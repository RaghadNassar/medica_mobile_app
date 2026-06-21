import 'package:flutter/material.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

class DoctorCommonCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String visitTime;
  final String? image;
  final String? clinic;
  final double? averageRating;
  final bool isFromTopDoctors;
  final VoidCallback onTap;

  const DoctorCommonCard({
    super.key,
    required this.name,
    required this.specialization,
    required this.visitTime,
    this.image,
    this.clinic,
    this.averageRating,
    required this.isFromTopDoctors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primaryContainer.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primaryContainer.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: context.heightPct(0.146),
              width: context.widthPct(0.25),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.08),
                borderRadius: const BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(16),
                  bottomStart: Radius.circular(16),
                ),
                child: image != null && image!.isNotEmpty
                    ? Image.network(
                        image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: theme.colorScheme.primary,
                            size: 38,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: theme.colorScheme.primary,
                          size: 38,
                        ),
                      ),
              ),
            ),

            // Container(
            //   height: context.heightPct(0.146),
            //   width: context.widthPct(0.25),
            //   decoration: BoxDecoration(
            //     color: theme.colorScheme.primaryContainer.withOpacity(0.08),
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(15),
            //       bottomLeft: Radius.circular(15),
            //     ),
            //   ),
            //   child: ClipRRect(
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(15),
            //       bottomLeft: Radius.circular(15),
            //     ),
            //     child: image != null && image!.isNotEmpty
            //         ? Image.network(
            //             image!,
            //             fit: BoxFit.cover,
            //             errorBuilder: (context, error, stackTrace) => Center(
            //               child: Icon(
            //                 Icons.person_rounded,
            //                 color: theme.colorScheme.primary,
            //                 size: 38,
            //               ),
            //             ),
            //           )
            //         : Center(
            //             child: Icon(
            //               Icons.person_rounded,
            //               color: theme.colorScheme.primary,
            //               size: 38,
            //             ),
            //           ),
            //   ),
            // ),
            SizedBox(width: context.widthPct(0.05)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: context.heightPct(0.018)),
                  Text(
                    name.startsWith('Dr.') || name.startsWith('Prof.')
                        ? name
                        : "Dr. $name",
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.heightPct(0.018)),
                  Text(
                    specialization,
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: context.heightPct(0.005)),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: theme.colorScheme.primary,
                              size: 12,
                            ),
                            SizedBox(width: context.widthPct(0.015)),
                            Text(
                              (averageRating ?? 4.0).toStringAsFixed(1),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: context.widthPct(0.3)),
                      Icon(
                        Icons.access_time_rounded,
                        color: theme.colorScheme.primary,
                        size: 14,
                      ),
                      SizedBox(width: context.widthPct(0.01)),
                      Text(
                        visitTime.length > 5
                            ? visitTime.substring(0, 5)
                            : visitTime,
                        style:
                            theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(0.018)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
