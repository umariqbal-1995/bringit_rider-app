import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../theme/app_colors.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  final bool isVerify;
  const AuthView({super.key, this.isVerify = false});

  @override
  Widget build(BuildContext context) {
    return isVerify ? _buildVerifyOtp(context) : _buildLogin(context);
  }

  Widget _buildLogin(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 280,
            color: AppColors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(Icons.directions_bike,
                        color: AppColors.primary, size: 40),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bring it',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Rider',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter your number',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "We'll send a verification code",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.greyBorder),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '🇵🇰 +92',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          onChanged: (v) => controller.phone.value = v,
                          decoration: const InputDecoration(
                            hintText: '3XX XXX XXXX',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Obx(() => ElevatedButton.icon(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.sendOtp,
                        icon: controller.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.send, size: 18),
                        label: const Text('Send OTP'),
                      )),
                  const Spacer(),
                  Center(
                    child: const Text(
                      'By continuing you agree to our Terms.',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyOtp(BuildContext context) {
    final sentPhone = Get.arguments?['phone'] ?? '';
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: Get.back,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Verify OTP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Code sent to $sentPhone',
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (v) => controller.otp.value = v,
              onCompleted: (_) => controller.verifyOtp(),
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 52,
                fieldWidth: 48,
                activeFillColor: AppColors.white,
                selectedFillColor: AppColors.white,
                inactiveFillColor: AppColors.white,
                activeColor: AppColors.primary,
                selectedColor: AppColors.primary,
                inactiveColor: AppColors.greyBorder,
              ),
              enableActiveFill: true,
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton.icon(
                  onPressed:
                      controller.isLoading.value ? null : controller.verifyOtp,
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.verified_outlined, size: 18),
                  label: const Text('Verify & Continue'),
                )),
            const SizedBox(height: 20),
            Center(
              child: Obx(() => TextButton(
                    onPressed: controller.countdown.value == 0
                        ? controller.resendOtp
                        : null,
                    child: Text(
                      controller.countdown.value > 0
                          ? 'Resend in 0:${controller.countdown.value.toString().padLeft(2, '0')}'
                          : 'Resend OTP',
                      style: TextStyle(
                        color: controller.countdown.value > 0
                            ? AppColors.textSecondary
                            : AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
