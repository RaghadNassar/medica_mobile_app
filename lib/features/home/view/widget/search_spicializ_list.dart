import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/controller/search_controller.dart';
import 'package:raghad_pro/features/home/view/screen/all_doctor_spicialize_screen.dart';
/*
class SearchSpecializationsList extends StatelessWidget {
  final List<dynamic> specializations;
  final HomeController homeController;

  const SearchSpecializationsList({
    super.key,
    required this.specializations,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding:AppSpacing.screenPadding12_6,
          child: Text(
            'الاختصاصات المتاحة',
            style: theme.textTheme.headlineLarge,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: specializations.length,
          itemBuilder: (context, index) {
            final spec = specializations[index];
            return Container(
              margin: AppSpacing.vertical,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.08),
                ),
              ),
              child: ListTile(

                title: Text(
                  spec.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.primary.withOpacity(0.6),
                ),
                onTap: () => _handleSpecialtyTap(spec),
              ),
            );
          },
        ),
         SizedBox(height: context.heightPct(0.08)),
      ],
    );
  }

  void _handleSpecialtyTap(dynamic spec) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    await homeController.getDoctorsBySpecialty(spec.uuid.toString());

    Get.back(); 

    Get.to(() => AllDoctorSpecializeScreen(
          specialtyName: spec.name,
          specialtyUuid: spec.uuid.toString(),
        ));
  }
}*/
class SearchSpecializationsList extends StatelessWidget {
  final List<dynamic> specializations;
  final PatientSearchController searchController; // الاعتماد على متحكم البحث نفسه

  const SearchSpecializationsList({
    super.key,
    required this.specializations,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPadding12_6,
          child: Text(
            'الاختصاصات المتاحة',
            style: theme.textTheme.headlineLarge,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: specializations.length,
          itemBuilder: (context, index) {
            final spec = specializations[index];
            return Container(
              margin: AppSpacing.vertical,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.08),
                ),
              ),
              child: ListTile(
                title: Text(
                  spec.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.primary.withOpacity(0.6),
                ),
                onTap: () => _handleSpecialtyTap(spec),
              ),
            );
          },
        ),
        SizedBox(height: context.heightPct(0.08)),
      ],
    );
  }

  void _handleSpecialtyTap(dynamic spec) {
    // 💡 الحل الهندسي النظيف: لا داعي لعمل لودينج هنا أو طلب API مكرر.
    // ننتقل فوراً عبر المسار الاسمي ونمرر البيانات كـ Arguments،
    // وشاشة الدكاترة ستتولى عرض الـ Skeletonizer وجلب البيانات تلقائياً بمرونة.
    Get.toNamed(
      AppRoutes.alldoctor, // أو المسار المعرّف لشاشة كل الدكاترة في AppPages
      arguments: {
        'specialtyName': spec.name,
        'specialtyUuid': spec.uuid.toString(),
      },
    );
  }
}