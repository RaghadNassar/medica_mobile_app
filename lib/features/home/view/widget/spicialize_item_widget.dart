// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:raghad_pro/core/constanse/app_assets.dart';
// import 'package:raghad_pro/core/constanse/app_spacing.dart';
// import 'package:raghad_pro/core/utilis/size_config.dart';

// class SpecialtyItemWidget extends StatelessWidget {
//   final VoidCallback onTap;

//   const SpecialtyItemWidget({
//     super.key,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: AppSpacing.edgeInsets16,
//             height: context.heightPct(0.1),
//             width: context.widthPct(0.166),
//             decoration: BoxDecoration(
//               color: theme.colorScheme.surface,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.03),
//                   blurRadius: AppSpacing.borderRadiusSecondry,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: SvgPicture.asset(
//               Appassets.heartSpicialize,
//             ),
//           ),
//           SizedBox(height: context.heightPct(0.01)),
//           Text('Heart', style: theme.textTheme.bodyMedium),
//         ],
//       ),
//     );
//   }
// }
