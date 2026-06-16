import 'package:flutter/material.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart'; 

// class CustomGenericTabs extends StatelessWidget {
//   final List<String> tabLabels;
//   final int selectedIndex;
//   final Function(int) onTabSelected;

//   const CustomGenericTabs({
//     super.key,
//     required this.tabLabels,
//     required this.selectedIndex,
//     required this.onTabSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(tabLabels.length, (index) {
//         final bool isSelected = selectedIndex == index;
//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.01)),
//             child: CustomBottomWidget(
//               text: tabLabels[index],
//               colortext: isSelected ? theme.colorScheme.surface : theme.primaryColor,
//               textColor: isSelected ? theme.colorScheme.surface : theme.primaryColor,
//               backgroundColor: isSelected ? theme.primaryColor : Colors.transparent,
//               border: Border.all(color: theme.primaryColor, width: 1.1),
//               borderradius: 12,
//               hight: context.heightPct(0.05),
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//               onTap: () => onTabSelected(index),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
class CustomGenericTabs extends StatelessWidget {
  final List<String> tabLabels;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomGenericTabs({
    super.key,
    required this.tabLabels,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(tabLabels.length, (index) {
        final bool isSelected = selectedIndex == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.01)),
            child: CustomBottomWidget(
              text: tabLabels[index],
              colortext: isSelected ? theme.colorScheme.surface : theme.primaryColor,
              textColor: isSelected ? theme.colorScheme.surface : theme.primaryColor,
              backgroundColor: isSelected ? theme.primaryColor : Colors.transparent,
              border: Border.all(color: theme.primaryColor, width: 1.1),
              borderradius: 12,
              hight: context.heightPct(0.05),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              onTap: () => onTabSelected(index),
            ),
          ),
        );
      }),
    );
  }
}