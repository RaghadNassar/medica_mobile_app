import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // هنا يمكنك استخدام Get.toNamed('/notifications'); لاحقاً
      },
      borderRadius: BorderRadius.circular(12), // لمسة جمالية عند الضغط
      child: Container(
        padding: AppSpacing.screenPadding5,
        child: SvgPicture.asset(
          Appassets.notificationIcon,
          width: context.widthPct(0.03),
          height: context.heightPct(0.03),
          colorFilter: ColorFilter.mode(
            // الوصول للون الأيقونات من الثيم مباشرة
            Theme.of(context).iconTheme.color ?? Colors.black,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
