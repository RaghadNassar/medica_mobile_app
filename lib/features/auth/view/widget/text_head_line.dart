import 'package:flutter/material.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_text.dart';

class CustomTextHeadLineWidget extends StatelessWidget {
  const CustomTextHeadLineWidget({super.key, required this.title});
  final String title ;

  @override
  Widget build(BuildContext context) {
    return   CustomText(
                  title:title,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(height: context.heightPct(0.002), fontSize: 28),
                );
  }
}