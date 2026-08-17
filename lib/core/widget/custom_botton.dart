import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';

class CustomBottomWidget extends StatelessWidget {
  final String text;
  VoidCallback? onTap;
  final Color? backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double? width;
  final double? hight;
  final bool isLoading;
  final double borderradius;
  final IconData? icon;
  final Border? border;

  CustomBottomWidget({
    required this.text,
    this.onTap,
    this.icon,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.width,
    this.hight = 50,
    this.isLoading = false,
    this.borderradius = 18,
    Key? key,
    required Color colortext,
    final int? fontsize, this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.screenPadding6,
        child: Container(
          decoration: BoxDecoration(
            color:   backgroundColor?? Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(borderradius),
            border:border?? Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
          ),
          width: width?? double.infinity,
          height: hight,
          child: icon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Icon(
                      icon,
                      color: AppColors.error,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                   
                  ],
                )
              : Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                ),
          //  ),
        ),
      ),
    );
  }
}
