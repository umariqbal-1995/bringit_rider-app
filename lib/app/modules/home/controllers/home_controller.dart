import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/rider_model.dart';
import '../../../data/providers/storage_provider.dart';
import '../../../data/repositories/rider_repository.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final RiderRepository _repo = RiderRepository();
  final StorageProvider _storage = StorageProvider();

  final rider = Rxn<RiderModel>();
  final assignedOrders = <OrderModel>[].obs;
  final isAvailable = false.obs;
  final isLoading = false.obs;
  final todayEarnings = 0.0.obs;
  final totalDeliveries = 0.obs;
  final rating = 4.9.obs;
  final selectedTab = 0.obs;

  Timer? _locationTimer;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadOrders();
    _startLocationUpdates();
  }

@override
  void onClose() {
    _locationTimer?.cancel();
    super.onClose();
  }

  Future<void> loadProfile() async {
    try {
      final r = await _repo.getMe();
      rider.value = r;
      isAvailable.value = r.isAvailable;
    } catch (_) {}
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      assignedOrders.value = await _repo.getAssignedOrders();
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> toggleAvailability(bool val) async {
    isAvailable.value = val;
    try {
      await _repo.updateAvailability(val);
    } catch (e) {
      isAvailable.value = !val;
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      await _repo.acceptOrder(orderId);
      await loadOrders();
      Get.toNamed(Routes.ORDER_DETAIL, arguments: {'orderId': orderId});
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> declineOrder(String orderId) async {
    try {
      await _repo.cancelOrder(orderId);
      await loadOrders();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (!isAvailable.value) return;
      try {
        final pos = await Geolocator.getCurrentPosition();
        await _repo.updateLocation(pos.latitude, pos.longitude);
      } catch (_) {}
    });
  }

  void logout() async {
    await _storage.clearAll();
    Get.offAllNamed(Routes.AUTH);
  }
}
