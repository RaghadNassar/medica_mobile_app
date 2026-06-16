import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/home/view/widget/notification_bottom.dart';
import 'package:raghad_pro/features/splash/view/widget/app_logo.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: AppSpacing.screenPadding16_10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            AppLogoWithText(
              imageLogo: Appassets.logoSecondry,
              colorImage: Theme.of(context).primaryColor,
              direction: Axis.horizontal,
              logoHeight: context.heightPct(0.051),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            //const Spacer(),
            //CustomText(title: 'Hello Dear..', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20,fontWeight: FontWeight.w600),),
            const Spacer(flex: 10),
            const NotificationButton(), // ويدجت مستقلة للأيقونة
          ],
        ),
      ),
    );
  }
}
