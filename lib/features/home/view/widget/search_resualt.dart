import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_assets.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/widget/null_data_widget.dart';
import 'package:raghad_pro/features/home/controller/home_controller.dart';
import 'package:raghad_pro/features/home/controller/search_controller.dart';
import 'package:raghad_pro/features/home/view/widget/search_doctor_list.dart';
import 'package:raghad_pro/features/home/view/widget/search_spicializ_list.dart';
/*
class SearchResultsView extends StatelessWidget {
  final PatientSearchController searchController;
  final HomeController homeController;

  const SearchResultsView({
    super.key,
    required this.searchController,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (searchController.isSearchLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (searchController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Text(
            searchController.errorMessage.value,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        );
      }

      final hasDoctors = searchController.searchedDoctors.isNotEmpty;
      final hasSpecs = searchController.searchedSpecializations.isNotEmpty;
      final isQueryNotEmpty = searchController.searchTextController.text.trim().isNotEmpty;

      if (!hasDoctors && !hasSpecs && isQueryNotEmpty) {
        return NullDataWidget(text: StringManager.noResultsFound, imagePath: Appassets.logoApp);
      }
      if (!isQueryNotEmpty) {
        return const Center(child: Text('ابدأ بكتابة كلمات البحث للاستكشاف.'));
      }

      return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          if (hasSpecs)
            SearchSpecializationsList(
              specializations: searchController.searchedSpecializations,
              homeController: homeController,
            ),
          if (hasDoctors)
            SearchDoctorsList(
              doctors: searchController.searchedDoctors,
              homeController: homeController,
            ),
        ],
      );
    });
  }
}*/
class SearchResultsView extends StatelessWidget {
  final PatientSearchController searchController;

  const SearchResultsView({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (searchController.isSearchLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (searchController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Text(
            searchController.errorMessage.value,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        );
      }

      final hasDoctors = searchController.searchedDoctors.isNotEmpty;
      final hasSpecs = searchController.searchedSpecializations.isNotEmpty;
      final isQueryNotEmpty = searchController.searchTextController.text.trim().isNotEmpty;

      if (!hasDoctors && !hasSpecs && isQueryNotEmpty) {
        return NullDataWidget(text: StringManager.noResultsFound, imagePath: Appassets.logoApp);
      }
      if (!isQueryNotEmpty) {
        return const Center(child: Text('ابدأ بكتابة كلمات البحث للاستكشاف.'));
      }

      return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          if (hasSpecs)
            SearchSpecializationsList(
              specializations: searchController.searchedSpecializations,
              searchController: searchController, // نمرر متحكم البحث فقط
            ),
          if (hasDoctors)
            SearchDoctorsList(
              doctors: searchController.searchedDoctors, // لا نمرر أي متحكم هنا
            ),
        ],
      );
    });
  }
}