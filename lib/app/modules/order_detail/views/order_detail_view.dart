import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../data/models/order_model.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Text(controller.order.value?.orderNumber ?? 'Order Detail')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: Get.back,
        ),
        actions: [
          Obx(() {
            final created = controller.order.value?.createdAt;
            if (created == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Today, ${created.hour}:${created.minute.toString().padLeft(2, '0')} ${created.hour >= 12 ? 'PM' : 'AM'}',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final order = controller.order.value;
        if (order == null) {
          return const Center(child: Text('Order not found'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBanner(order),
              const SizedBox(height: 16),
              _buildRouteCard(order),
              const SizedBox(height: 16),
              _buildItemsCard(order),
              const SizedBox(height: 16),
              _buildEarningCard(order),
              const SizedBox(height: 16),
              _buildUpdateStatus(),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildStatusBanner(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _statusLabel(order.status),
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary),
              ),
              Text(
                'Order collected from ${order.storeName}',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ROUTE',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),
          _RoutePoint(
            color: AppColors.primary,
            title: order.storeName,
            subtitle: order.storeAddress,
            isStart: true,
          ),
          Container(
            margin: const EdgeInsets.only(left: 5),
            height: 20,
            width: 1.5,
            color: AppColors.greyBorder,
          ),
          _RoutePoint(
            color: AppColors.onlineGreen,
            title: order.customerName,
            subtitle: order.customerAddress,
            phone: order.customerPhone,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDER ITEMS',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(item.name,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textPrimary)),
                    ),
                    Text(
                      'Rs. ${item.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEarningCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Delivery Earning',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(
                  'Rs. ${order.earning.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${order.distance.toStringAsFixed(1)} km',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time_outlined,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('~${order.estimatedMinutes} min',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UPDATE STATUS',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),
          Obx(() => _StatusStep(
                icon: Icons.check_circle_outline,
                label: 'Mark as Picked Up',
                isActive: controller.canPickup,
                isDone: !controller.canPickup && controller.order.value != null,
                onTap: controller.canPickup ? controller.markPickedUp : null,
              )),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Obx(() {
        if (controller.order.value == null) return const SizedBox.shrink();
        final isLoading = controller.isActionLoading.value;

        if (controller.canPickup) {
          return ElevatedButton.icon(
            onPressed: isLoading ? null : controller.markPickedUp,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.shopping_bag_outlined, size: 18),
            label: const Text('Picked Up — Start Delivery'),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'accepted':
        return 'Assigned';
      case 'picked_up':
        return 'Picked Up';
      case 'delivering':
        return 'On the Way';
      case 'completed':
        return 'Delivered';
      default:
        return status[0].toUpperCase() + status.substring(1);
    }
  }
}

class _RoutePoint extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String? phone;
  final bool isStart;

  const _RoutePoint({
    required this.color,
    required this.title,
    required this.subtitle,
    this.phone,
    this.isStart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
        if (phone != null)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined,
                color: AppColors.primary, size: 20),
          ),
      ],
    );
  }
}

class _StatusStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDone;
  final VoidCallback? onTap;

  const _StatusStep({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isDone = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryLight
              : isDone
                  ? AppColors.onlineGreen.withOpacity(0.08)
                  : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isActive
                  ? AppColors.primary.withOpacity(0.4)
                  : AppColors.greyBorder),
        ),
        child: Row(
          children: [
            Icon(
              isDone ? Icons.check_circle : icon,
              color: isDone
                  ? AppColors.onlineGreen
                  : isActive
                      ? AppColors.primary
                      : AppColors.grey,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDone
                      ? AppColors.onlineGreen
                      : isActive
                          ? AppColors.primary
                          : AppColors.grey),
            ),
            if (isDone) ...[
              const Spacer(),
              const Icon(Icons.check_circle, color: AppColors.onlineGreen, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
