import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/widget/custom_card_top_doctor.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';

class SearchDoctorsList extends StatelessWidget {
  final List<dynamic> doctors;
  final HomeController homeController;

  const SearchDoctorsList({
    super.key,
    required this.doctors,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
          child: Text(
            'الأطباء المتاحون',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: DoctorCommonCard(
                name: doctor.name,
                specialization: doctor.specialization,
                visitTime: doctor.visitTime,
                image: doctor.image,
                clinic: doctor.clinic,
                averageRating: doctor.averageRating,
                isFromTopDoctors: false,
                onTap: () => _handleDoctorTap(doctor),
              ),
            );
          },
        ),
      ],
    );
  }

  void _handleDoctorTap(dynamic doctor) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    homeController.initDoctorDetailsFromSearch(doctor);

    await Future.delayed(const Duration(milliseconds: 150));
    Get.back();

    Get.toNamed(AppRoutes.detail);
  }
}
