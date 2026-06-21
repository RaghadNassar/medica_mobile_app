import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';

class ImageBannerSlideItem extends StatelessWidget {
  final String imagePath;

  const ImageBannerSlideItem({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.horizontal12,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.black.withOpacity(0.2),
                    AppColors.black.withOpacity(0.07),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





















































































/*
class BannerSlideItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tag;
  final String title;
  final String desc;

  const BannerSlideItem({
    super.key,
    required this.icon,
    required this.color,
    required this.tag,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(0.04),
        vertical: context.heightPct(0.015),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                Container(
                  padding:AppSpacing. screenPadding12_6,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: color, size: 16),
                      SizedBox(width: context.widthPct(0.01)),
                      Text(
                        tag,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.heightPct(0.01)),
                
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(height: context.heightPct(0.01)),

                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 35),
        ],
      ),
    );
  }
}
*/

// class BannerImageData {
//   final String image;

//   BannerImageData({
//     required this.image,
//   });
// }

// List<BannerImageData> medicalBanners = [
//   BannerImageData(
//     image: Appassets.pannar5,
//   ),
//   BannerImageData(
//     image: Appassets.pannar6,
//   ),
//   BannerImageData(
//     image: Appassets.pannar2,
//   ),
//   BannerImageData(
//     image: Appassets.pannar3,
//   ),
//   BannerImageData(
//     image: Appassets.pannar4,
//   ),
// ];