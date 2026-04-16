import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/rider_repository.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final RiderRepository _repo = RiderRepository();

  final currentStep = 0.obs;
  final isLoading = false.obs;
  final nameController = TextEditingController();
  final cnicController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    cnicController.dispose();
    super.onClose();
  }

  Future<void> continueOnboarding() async {
    if (currentStep.value == 0) {
      if (nameController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Enter your full name',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      currentStep.value = 1;
      return;
    }
    if (currentStep.value == 1) {
      await _saveProfile();
    }
  }

  Future<void> _saveProfile() async {
    isLoading.value = true;
    try {
      await _repo.updateMe({'name': nameController.text.trim()});
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    isLoading.value = false;
  }

  String get stepLabel => 'Step ${currentStep.value + 1} of 3';
}
