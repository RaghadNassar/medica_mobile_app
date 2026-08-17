import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/features/home/data/repositry/repostry_home.dart';

class PatientSearchController extends GetxController {
  final RepostryHome repostryHome;
  PatientSearchController(this.repostryHome);

  final TextEditingController searchTextController = TextEditingController();
  Timer? _debounceTimer;

  var isSearchLoading = false.obs;
  var errorMessage = ''.obs;
  var activeSearchTab = 0.obs;

  var searchedDoctors = <dynamic>[].obs;
  var searchedSpecializations = <dynamic>[].obs;

  final List<String> _searchTypes = ['all', 'doctors', 'specializations'];

  var isDoctorsBySpecLoading = false.obs;
  var doctorsBySpecialty = <dynamic>[].obs;

  void onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        triggerSearch(query: query.trim());
      } else {
        clearSearchResults();
      }
    });
  }

  Future<void> triggerSearch({String? query}) async {
    final searchKey = query ?? searchTextController.text.trim();
    if (searchKey.isEmpty) return;

    isSearchLoading.value = true;
    errorMessage.value = '';

    String currentType = _searchTypes[activeSearchTab.value];

    final result = await repostryHome.getSearch(
      query: searchKey,
      searchType: currentType,
    );

    result.fold(
      (error) => _handleError(error),
      (response) {
        isSearchLoading.value = false;
        searchedDoctors.assignAll(response.doctors);
        searchedSpecializations.assignAll(response.specializations);
      },
    );
  }

  void updateSearchTab(int index) {
    activeSearchTab.value = index;
    if (searchTextController.text.trim().isNotEmpty) {
      triggerSearch();
    }
  }

  void _handleError(String error) {
    isSearchLoading.value = false;
    errorMessage.value = error;
  }

  void clearSearchResults() {
    searchedDoctors.clear();
    searchedSpecializations.clear();
    errorMessage.value = '';
    isSearchLoading.value = false;
  }

  Future<void> getDoctorsBySpecialty(String specialtyId) async {
    isDoctorsBySpecLoading.value = true;
    doctorsBySpecialty.clear();

    final response = await repostryHome.getDoctorsBySpecialty(specialtyId);

    response.fold(
      (err) {
        isDoctorsBySpecLoading.value = false;
        debugPrint("Doctors by Specialty Error: $err");
      },
      (doctorsData) {
        isDoctorsBySpecLoading.value = false;
        doctorsBySpecialty.assignAll(doctorsData.data ?? []);
      },
    );
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchTextController.dispose();
    super.onClose();
  }
}







































































/*
class PatientSearchController extends GetxController {
  final RepostryHome repostryHome;
  PatientSearchController(this.repostryHome);

  final TextEditingController searchTextController = TextEditingController();
  Timer? _debounceTimer;

  var isSearchLoading = false.obs;
  var errorMessage = ''.obs;
  var activeSearchTab = 0.obs; // 0 = all, 1 = doctors, 2 = specializations

  // var searchedDoctors = <TopDoctorModel>[].obs;
  // var searchedSpecializations = <SpecializationModel>[].obs;
  var searchedDoctors = <SearchDoctorItem>[].obs;
  var searchedSpecializations = <SearchSpecializationItem>[].obs;
  final List<String> _searchTypes = ['all', 'doctors', 'specializations'];

  void onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        triggerSearch(query: query.trim());
      } else {
        clearSearchResults();
      }
    });
  }

  Future<void> triggerSearch({String? query}) async {
    final searchKey = query ?? searchTextController.text.trim();
    if (searchKey.isEmpty) return;

    isSearchLoading.value = true;
    errorMessage.value = '';

    String currentType = _searchTypes[activeSearchTab.value];

    final result = await repostryHome.getSearch(
      query: searchKey,
      searchType: currentType,
    );

    result.fold(
      (error) => _handleError(error),
      (response) {
        //
        isSearchLoading.value = false;

        searchedDoctors.assignAll(response.doctors);
        searchedSpecializations.assignAll(response.specializations);
      },
    );
  }

  void updateSearchTab(int index) {
    activeSearchTab.value = index;
    if (searchTextController.text.trim().isNotEmpty) {
      triggerSearch();
    }
  }

  void _handleError(String error) {
    isSearchLoading.value = false;
    errorMessage.value = error;
  }

  void clearSearchResults() {
    searchedDoctors.clear();
    searchedSpecializations.clear();
    errorMessage.value = '';
    isSearchLoading.value = false;
  }
 
 
  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchTextController.dispose();
    super.onClose();
  }
}*/