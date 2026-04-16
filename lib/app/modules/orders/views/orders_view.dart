import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../data/models/order_model.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  final bool embedded;
  const OrdersView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        _buildFilterChips(),
        Expanded(child: _buildList()),
      ],
    );

    if (embedded) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Orders',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
            ),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: Get.back,
        ),
      ),
      body: content,
    );
  }

  Widget _buildFilterChips() {
    final filters = ['all', 'assigned', 'delivering', 'completed'];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final f = filters[i];
          return Obx(() {
            final selected = controller.selectedFilter.value == f;
            return GestureDetector(
              onTap: () => controller.selectedFilter.value = f,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: selected ? AppColors.primary : AppColors.greyBorder),
                ),
                child: Text(
                  f[0].toUpperCase() + f.substring(1),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.white : AppColors.textSecondary),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: AppColors.primary));
      }
      final orders = controller.filteredOrders;
      return RefreshIndicator(
        onRefresh: controller.loadOrders,
        color: AppColors.primary,
        child: orders.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text('No orders found',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 15)),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                itemCount: orders.length,
                itemBuilder: (ctx, i) => _OrderListItem(
                  order: orders[i],
                  onTap: () => controller.openOrderDetail(orders[i].id),
                ),
              ),
      );
    });
  }
}

class _OrderListItem extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  const _OrderListItem({required this.order, required this.onTap});

  Color get _statusColor {
    switch (order.status) {
      case 'OUT_FOR_DELIVERY':
        return AppColors.primary;
      case 'DELIVERED':
        return AppColors.onlineGreen;
      case 'CANCELLED':
        return AppColors.error;
      case 'PREPARING':
        return AppColors.warning;
      default:
        return AppColors.grey;
    }
  }

  String get _statusLabel {
    switch (order.status) {
      case 'ACCEPTED':
        return 'Assigned';
      case 'PREPARING':
        return 'Preparing';
      case 'OUT_FOR_DELIVERY':
        return 'Delivering';
      case 'DELIVERED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return order.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shopping_bag_outlined,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.orderNumber,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(order.storeName,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                  Text(order.timeAgo,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Rs. ${order.earning.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _statusColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
