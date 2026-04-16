import 'package:get/get.dart';
import '../../../data/providers/notification_service.dart';
import '../../../data/providers/storage_provider.dart';
import '../../../data/repositories/rider_repository.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final RiderRepository _repo = RiderRepository();
  final StorageProvider _storage = StorageProvider();

  final phone = ''.obs;
  final otp = ''.obs;
  final isLoading = false.obs;
  final countdown = 45.obs;

  String get fullPhone => '+92${phone.value}';

  Future<void> sendOtp() async {
    if (phone.value.length < 10) {
      Get.snackbar('Error', 'Enter a valid phone number',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;
    try {
      await _repo.sendOtp(fullPhone);
      Get.toNamed(Routes.VERIFY_OTP, arguments: {'phone': fullPhone});
      _startCountdown();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      Get.snackbar('Error', 'Enter the 6-digit OTP',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;
    try {
      final res = await _repo.verifyOtp(
        Get.arguments?['phone'] ?? fullPhone,
        otp.value,
      );
      final data = res['data'] as Map<String, dynamic>? ?? res;
      final token = data['token'] as String? ?? data['accessToken'] as String? ?? '';
      await _storage.saveToken(token);
      unawaited(NotificationService().registerTokenAfterLogin());
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (countdown.value > 0) return;
    final sentPhone = Get.arguments?['phone'] ?? fullPhone;
    isLoading.value = true;
    try {
      await _repo.sendOtp(sentPhone);
      _startCountdown();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void _startCountdown() {
    countdown.value = 45;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (countdown.value > 0) countdown.value--;
      return countdown.value > 0;
    });
  }
}
