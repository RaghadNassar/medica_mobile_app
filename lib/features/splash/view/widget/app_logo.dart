
import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';

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
          StringManager.medica, 
          style: style,
        ),
      ],
    );
  }
}