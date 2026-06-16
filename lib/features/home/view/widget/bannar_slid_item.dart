import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

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
