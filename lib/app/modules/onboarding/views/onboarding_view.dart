import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: Get.back,
        ),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    controller.stepLabel,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textSecondary),
                  ),
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complete your profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Required to start delivering',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.greyLight,
                    child: const Icon(Icons.camera_alt,
                        size: 32, color: AppColors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add,
                          size: 16, color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Upload Photo',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Full Name',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(hintText: 'Your full name'),
            ),
            const SizedBox(height: 20),
            const Text(
              'CNIC / ID Number',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.cnicController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '12345-1234567-1'),
            ),
            const SizedBox(height: 20),
            _UploadBox(label: 'Upload ID Front'),
            const SizedBox(height: 12),
            _UploadBox(label: 'Upload ID Back'),
            const Spacer(),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.continueOnboarding,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Continue →'),
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final String label;
  const _UploadBox({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload, color: AppColors.grey, size: 20),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
