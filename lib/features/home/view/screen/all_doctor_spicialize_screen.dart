import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/app_route.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/widget/custom_card_top_doctor.dart';
import 'package:raghad_pro/core/widget/custom_skeletinizor.dart';
import 'package:raghad_pro/core/widget/null_data_widget.dart';
import 'package:raghad_pro/features/home/controller/doctor_book_logic.dart';
import 'package:skeletonizer/skeletonizer.dart';
/*
class AllDoctorSpecializeScreen extends GetView<DoctorBookingController> {
  
  const AllDoctorSpecializeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String specialtyName = args['specialtyName'] ?? '';
    final String specialtyUuid = args['specialtyUuid'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (specialtyUuid.isNotEmpty) {
        controller.getDoctorsBySpecialty(specialtyUuid);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(specialtyName),
        centerTitle: true,
      ),
      body: Obx(() {
        if (!controller.isDoctorsBySpecLoading.value &&
            controller.doctorsBySpecialty.isEmpty) {
          return NullDataWidget(
            text: StringManager.noDoctorsAvailable,
            imagePath: Appassets.logoSecondry,
          );
        }

        final bool isLoading = controller.isDoctorsBySpecLoading.value;

        return Skeletonizer(
          enabled: isLoading,
          effect: const ShimmerEffect(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            duration: Duration(milliseconds: 3000),
          ),
          child: ListView.builder(
            padding: AppSpacing.edgeInsets18,
            itemCount: isLoading ? 3 : controller.doctorsBySpecialty.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final doctor = isLoading ? null : controller.doctorsBySpecialty[index];

              return Padding(
                padding: AppSpacing.bottom16,
                child: DoctorCommonCard(
                  name: doctor?.name ?? "Dr. Doctor Name Placeholder",
                  specialization: doctor?.specialization ?? "Specialization Info",
                  visitTime: doctor?.visitTime ?? "00:00 AM - 00:00 PM",
                  image: doctor?.image,
                  clinic: doctor?.clinic,
                  averageRating: doctor?.averageRating ?? 0.0,
                  isFromTopDoctors: false,
                  onTap: () {
                    if (controller.isDoctorsBySpecLoading.value) return;

                    if (doctor != null) {
                      
                      controller.initDoctorDetails(doctor);
                      Get.toNamed(AppRoutes.detail, arguments: doctor);
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
*/
class AllDoctorSpecializeScreen extends GetView<DoctorBookingController> {
  const AllDoctorSpecializeScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    final args          = Get.arguments as Map<String, dynamic>? ?? {};
    final specialtyName = args['specialtyName'] as String? ?? '';
    final specialtyUuid = args['specialtyUuid'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(
        
        title: Text(specialtyName),
        centerTitle: true,
      ),
      body: _SpecialtyDoctorsList(
        specialtyUuid: specialtyUuid,
        controller: controller,
      ),
    );
  }
}
class _SpecialtyDoctorsList extends StatefulWidget {
  final String specialtyUuid;
  final DoctorBookingController controller;

  const _SpecialtyDoctorsList({
    required this.specialtyUuid,
    required this.controller,
  });

  @override
  State<_SpecialtyDoctorsList> createState() => _SpecialtyDoctorsListState();
}

class _SpecialtyDoctorsListState extends State<_SpecialtyDoctorsList> {
  @override
  void initState() {
    super.initState();
    if (widget.specialtyUuid.isNotEmpty) {
      widget.controller.getDoctorsBySpecialty(widget.specialtyUuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = widget.controller.isDoctorsBySpecLoading.value;
      final doctors   = widget.controller.doctorsBySpecialty;

      
      if (!isLoading && doctors.isEmpty) {
        return NullDataWidget(
          text: StringManager.noDoctorsAvailable.tr,
          imagePath: Appassets.logoSecondry,
        );
      }

   return CustomSkeletonizer(
  isLoading: isLoading,
  child: ListView.builder(
    padding: AppSpacing.edgeInsets18,
    itemCount: isLoading ? 3 : doctors.length, 
    physics: const BouncingScrollPhysics(),
    itemBuilder: (context, index) {
      final doctor = isLoading ? null : doctors[index];

      return Padding(
        padding: AppSpacing.bottom16,
        child: DoctorCommonCard(
          name:           doctor?.name           ?? 'Dr. Doctor Name',
          specialization: doctor?.specialization ?? 'Specialization',
          visitTime:      doctor?.visitTime      ?? '00:00 - 00:00',
          image:          doctor?.image,
          clinic:         doctor?.clinic,
          averageRating:  doctor?.averageRating  ?? 0.0,
          isFromTopDoctors: false,
          onTap: () {
            if (isLoading || doctor == null) return;
            widget.controller.initDoctorDetails(doctor);
            Get.toNamed(AppRoutes.detail, arguments: doctor);
          },
        ),
      );
    },
  ),
);
    });
  }
}



























/*
class AllDoctorSpecializeScreen extends GetView<HomeController> {
  final String specialtyName;
  final String specialtyUuid;

  const AllDoctorSpecializeScreen({
    super.key,
    required this.specialtyName,
    required this.specialtyUuid,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getDoctorsBySpecialty(specialtyUuid);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(specialtyName),
        centerTitle: true,
      ),
      body: Obx(() {
        if (!controller.isDoctorsBySpecLoading.value &&
            controller.doctorsBySpecialty.isEmpty) {
          return NullDataWidget(text: StringManager.noDoctorsAvailable, imagePath: Appassets.logoSecondry,);
        }

        final bool isLoading = controller.isDoctorsBySpecLoading.value;

        return Skeletonizer(
          enabled: isLoading,
          effect: const ShimmerEffect(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            duration: Duration(milliseconds: 3000),
          ),
          child: ListView.builder(
            padding: AppSpacing.edgeInsets18,
            itemCount: isLoading ? 3 : controller.doctorsBySpecialty.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final doctor =
                  isLoading ? null : controller.doctorsBySpecialty[index];

              return Padding(
                padding: AppSpacing.bottom16,
                child: DoctorCommonCard(
                  name: doctor?.name ?? "Dr. Doctor Name Placeholder",
                  specialization:
                      doctor?.specialization ?? "Specialization Info",
                  visitTime: doctor?.visitTime ?? "00:00 AM - 00:00 PM",
                  image: doctor?.image,
                  clinic: doctor?.clinic,
                  averageRating: doctor?.averageRating ?? 0.0,
                 // patientsCount: doctor?.patientsCount ?? 0,
                  isFromTopDoctors: false,
                  onTap: () {
                    if (controller.isDoctorsBySpecLoading.value) return;

                    if (doctor != null) {
                      controller.initDoctorDetails(doctor);
                     // Get.find<HomeController>().initDoctorDetails(doctor);
                      Get.toNamed(AppRoutes.detail, arguments: doctor);
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}*/








/*
class AllDoctorSpecializeScreen extends StatelessWidget {
  final String specialtyName; // اسم الاختصاص الذي سيظهر في الـ AppBar
 final String specialtyUuid;
  const AllDoctorSpecializeScreen({
    super.key,
    required this.specialtyName, required this.specialtyUuid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(specialtyName),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: AppSpacing.edgeInsets18,
        itemCount:
            10, // هذا الرقم سيأتي من الـ Controller بناءً على عدد الأطباء
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: AppSpacing.bottom16,
            child: TopDoctorCard(
              onTap: () {
                // الانتقال لصفحة تفاصيل الدكتور
              }, doctor: TopDoctorModel(uuid: '', name: '', specialization: '', averageRating: 4, visitTime: ''),
            ),
          );
        },
      ),
    );
  }
}
*/