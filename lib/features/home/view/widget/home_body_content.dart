import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_text.dart';
import 'package:raghad_pro/core/widget/custom_text_filed.dart';
import 'package:raghad_pro/features/home/view/widget/promo_bannar.dart';
import 'package:raghad_pro/features/home/view/widget/spicaliz_section_widget.dart';
import 'package:raghad_pro/features/home/view/widget/top_doctor_list_widget.dart';

class HomeBodyContent extends StatelessWidget {
  const HomeBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppSpacing.screenPadding4,
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // const CustomTextFiled(
          //   hinttext: StringManager.searchDoctor,
          //   prefixIcon: Icons.search,
          //   suffixIcon: Icons.keyboard_voice,
          // ),
          CustomTextFiled(
            hinttext: StringManager.searchDoctor.tr,
            prefixIcon: Icons.search,
            suffixIcon: Icons.close,
            readOnly: true,
            onTap: () => Get.toNamed(AppRoutes.search),
          ),
          SizedBox(height: context.heightPct(0.02)),

          const HomeBannerCard(),
          SizedBox(height: context.heightPct(0.02)),

          CustomText(
            title: StringManager.specializeDoctor.tr,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 20),
          ),
          // SizedBox(height: context.heightPct(0.01)),
          const SpecialtySection(),
          SizedBox(height: context.heightPct(0.029)),

          CustomText(
            title: StringManager.topDoctor.tr,
            style: Theme.of(context).textTheme.headlineLarge!,
          ),
          SizedBox(height: context.heightPct(0.01)),

          const TopDoctorsList(),
        ]),
      ),
    );
  }
}





































/*class HomeBodyContent extends StatelessWidget {
  final TopDoctorModel topDoctor;
  const HomeBodyContent({super.key, required this.topDoctor});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppSpacing.edgeInsets16,
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const CustomTextFiled(
            hinttext: StringManager.searchDoctor,
            prefixIcon: Icons.search,
            suffixIcon: Icons.keyboard_voice,
          ),
           SizedBox(height: context.heightPct(0.02)),
           // قائمة الاختصاصات
         const HomeBannerCard(),
       // const HomeStatsBar(),
         SizedBox(height: context.heightPct(0.02)),
           CustomText(title: StringManager.specializeDoctor,style: Theme.of(context).textTheme.headlineLarge!,),
            SizedBox(height: context.heightPct(0.01)),
          const SpecialtySection(),
           CustomText(title: StringManager.topDoctor,style: Theme.of(context).textTheme.headlineLarge!,), // عنوان القسم
           SizedBox(height: context.heightPct(0.01)),
          DoctorCommonCard(
            name: topDoctor.name,
            specialization: topDoctor.specialization,
            visitTime: topDoctor.visitTime,
            image: topDoctor.image,
            averageRating: topDoctor.averageRating,
            showRating: true, // 🌟 تفعيل كشاف التقييم
            onTap: () {},
          ), // قائمة الأطباء
        ]),
      ),
    );
  }
}*/