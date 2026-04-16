import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/rider_repository.dart';
import '../../../routes/app_pages.dart';

class OrdersController extends GetxController {
  final RiderRepository _repo = RiderRepository();

  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final selectedFilter = 'all'.obs;

  // Map chip labels → backend status values
  static const _filterMap = {
    'assigned': ['ACCEPTED', 'PREPARING'],
    'delivering': ['OUT_FOR_DELIVERY'],
    'completed': ['DELIVERED', 'CANCELLED'],
  };

  List<OrderModel> get filteredOrders {
    final f = selectedFilter.value;
    if (f == 'all') return orders;
    final statuses = _filterMap[f] ?? [];
    return orders.where((o) => statuses.contains(o.status)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      orders.value = await _repo.getAssignedOrders();
    } catch (_) {}
    isLoading.value = false;
  }

  void openOrderDetail(String orderId) {
    final order = orders.firstWhereOrNull((o) => o.id == orderId);
    if (order?.status == 'OUT_FOR_DELIVERY') {
      Get.toNamed(Routes.NAVIGATION_MAP,
          arguments: {'orderId': orderId, 'order': order});
    } else {
      Get.toNamed(Routes.ORDER_DETAIL, arguments: {'orderId': orderId});
    }
  }
}
