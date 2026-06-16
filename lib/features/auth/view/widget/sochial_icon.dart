import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

class SochialIconWidget extends StatelessWidget {
  const SochialIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
           Text(
            "- OR Continue with -",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
           SizedBox(height: context.heightPct(0.02)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Appassets.svgGoogle),
               SizedBox(width:context.widthPct(0.05)),
              _socialIcon(Appassets.svgApple),
               SizedBox(width: context.widthPct(0.05)),
              _socialIcon(Appassets.svgFacebook),
            ],
          ),
        ],
      ),
    );
    

  }
    // ويدجت أيقونات السوشيال ميديا (SVG)
  Widget _socialIcon(String path) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accentTeal .withOpacity(0.3)),
      ),
      child: SvgPicture.asset(
        path,
        height: 28,
        width: 28,
      ),
    );
  }
}
