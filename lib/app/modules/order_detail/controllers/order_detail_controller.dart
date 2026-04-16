import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/rider_repository.dart';
import '../../../routes/app_pages.dart';

class OrderDetailController extends GetxController {
  final RiderRepository _repo = RiderRepository();

  final order = Rxn<OrderModel>();
  final isLoading = false.obs;
  final isActionLoading = false.obs;

  String get orderId => Get.arguments?['orderId'] ?? '';

  @override
  void onInit() {
    super.onInit();
    loadOrder();
  }

  Future<void> loadOrder() async {
    isLoading.value = true;
    try {
      order.value = await _repo.getOrder(orderId);
      // If rider already picked up and is en-route, go straight to map
      if (order.value?.status == 'OUT_FOR_DELIVERY') {
        Get.offNamed(Routes.NAVIGATION_MAP,
            arguments: {'orderId': orderId, 'order': order.value});
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    isLoading.value = false;
  }

  Future<void> markPickedUp() async {
    isActionLoading.value = true;
    try {
      await _repo.pickupOrder(orderId);
      final updated = await _repo.getOrder(orderId);
      order.value = updated;
      // Navigate to map to deliver to customer
      Get.offNamed(Routes.NAVIGATION_MAP,
          arguments: {'orderId': orderId, 'order': order.value});
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    isActionLoading.value = false;
  }

  // canPickup: store has the order ready, rider picks it up
  bool get canPickup => order.value?.status == 'PREPARING';
}
