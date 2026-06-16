// import 'package:flutter/material.dart';
// import 'package:raghad_pro/core/utilis/size_config.dart';
// // تأكدي من استيراد كلاس الألوان الخاص بكِ

// class AppLogoWithText extends StatelessWidget {
//   final double logoHeight;
//   final TextStyle style;
//   final String imageLogo;
//   final Color colorImage;

//   const AppLogoWithText({
//     super.key,
//     this.logoHeight = 75,
//     required this.imageLogo,
//     required this.colorImage,
//     required this.style,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // شعار السماعة
//         Image.asset(
//           imageLogo,
//           height: logoHeight,
//           // استخدام اللون الأساسي للتطبيق لضمان التطابق مع الاسم
//           color: colorImage,
//           colorBlendMode: BlendMode.srcIn,
//         ),
//         SizedBox(height: context.heightPct(0.001)),
//         // اسم التطبيق Medica
//         Text('Medica', style: style),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

class AppLogoWithText extends StatelessWidget {
  final double logoHeight;
  final TextStyle style;
  final String imageLogo;
  final Color colorImage;
  
  final Axis direction; 
  final double? verticalSpacing;
  final double? horizontalSpacing;

  const AppLogoWithText({
    super.key,
    this.logoHeight = 75,
    required this.imageLogo,
    required this.colorImage,
    required this.style,
    this.direction = Axis.vertical,this.verticalSpacing,
    this.horizontalSpacing, 
  });

  @override
  Widget build(BuildContext context) {
    
    final bool isVertical = direction == Axis.vertical;

    return Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        
        Image.asset(
          imageLogo,
          height: logoHeight,
          color: colorImage,
          colorBlendMode: BlendMode.srcIn,
        ),

      
        isVertical ? SizedBox(height: logoHeight * 0.1) :const SizedBox(width: 1),

        
        Text(
          'Medica', 
          style: style,
        ),
      ],
    );
  }
}