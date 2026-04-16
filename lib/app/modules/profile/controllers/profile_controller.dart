import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/rider_model.dart';
import '../../../data/providers/storage_provider.dart';
import '../../../data/repositories/rider_repository.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final RiderRepository _repo = RiderRepository();
  final StorageProvider _storage = StorageProvider();

  final rider = Rxn<RiderModel>();
  final isLoading = false.obs;
  final isSaving = false.obs;
  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final r = await _repo.getMe();
      rider.value = r;
      nameController.text = r.name;
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) return;
    isSaving.value = true;
    try {
      final updated = await _repo.updateMe({'name': nameController.text.trim()});
      rider.value = updated;
      Get.snackbar('Success', 'Profile updated', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    isSaving.value = false;
  }

  void logout() async {
    await _storage.clearAll();
    Get.offAllNamed(Routes.AUTH);
  }
}
