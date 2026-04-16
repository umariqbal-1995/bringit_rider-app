import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../data/models/order_model.dart';
import '../controllers/home_controller.dart';
import '../../orders/views/orders_view.dart';
import '../../analytics/views/analytics_view.dart';
import '../../profile/views/profile_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tabs = [
        _HomeTab(controller: controller),
        const OrdersView(embedded: true),
        const AnalyticsView(embedded: true),
        const ProfileView(embedded: true),
      ];
      return Scaffold(
        backgroundColor: AppColors.background,
        body: tabs[controller.selectedTab.value],
        bottomNavigationBar: _BottomNav(controller: controller),
      );
    });
  }
}

class _HomeTab extends StatelessWidget {
  final HomeController controller;
  const _HomeTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.loadOrders,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildStatsRow()),
            SliverToBoxAdapter(child: _buildNewOrdersBanner()),
            SliverToBoxAdapter(child: _buildOrdersHeader()),
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                );
              }
              if (controller.assignedOrders.isEmpty) {
                return const SliverToBoxAdapter(child: _EmptyOrders());
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _OrderCard(
                    order: controller.assignedOrders[i],
                    onAccept: () =>
                        controller.acceptOrder(controller.assignedOrders[i].id),
                    onDecline: () =>
                        controller.declineOrder(controller.assignedOrders[i].id),
                  ),
                  childCount: controller.assignedOrders.length,
                ),
              );
            }),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Obx(() => CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary,
                child: Text(
                  controller.rider.value?.name.isNotEmpty == true
                      ? controller.rider.value!.name[0].toUpperCase()
                      : 'R',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
              )),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      controller.rider.value?.name ?? 'Rider',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.textPrimary),
                    )),
                Obx(() => Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.isAvailable.value
                            ? AppColors.onlineGreen
                            : AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      controller.isAvailable.value ? 'Online' : 'Offline',
                      style: TextStyle(
                          fontSize: 13,
                          color: controller.isAvailable.value
                              ? AppColors.onlineGreen
                              : AppColors.grey),
                    ),
                    const Text(' · Karachi',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                  ],
                )),
              ],
            ),
          ),
          Obx(() => Switch(
                value: controller.isAvailable.value,
                onChanged: controller.toggleAvailability,
                activeColor: AppColors.primary,
              )),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: "Today's Earnings",
              value: 'Rs. 2,100',
              highlight: true,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              label: 'Deliveries',
              value: '8',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              label: 'Rating',
              value: '4.9 ★',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewOrdersBanner() {
    return Obx(() {
      if (controller.assignedOrders.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.notifications_active,
                color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              '${controller.assignedOrders.length} new orders available near you',
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOrdersHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Available Orders',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.assignedOrders.length}',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              )),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _StatCard(
      {required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 11,
                color: highlight ? AppColors.white.withOpacity(0.85) : AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: highlight ? AppColors.white : AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _OrderCard(
      {required this.order,
      required this.onAccept,
      required this.onDecline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs. ${order.earning.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textPrimary),
                  ),
                  const Text('Your earning',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${order.timeAgo} · ${order.totalItems} items',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          _LocationRow(
              dot: AppColors.primary,
              text: '${order.storeName}, ${order.storeAddress}'),
          const SizedBox(height: 6),
          _LocationRow(
              dot: AppColors.onlineGreen,
              text: '${order.customerName}, ${order.customerAddress}'),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${order.distance.toStringAsFixed(1)} km',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '~${order.estimatedMinutes} min',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.greyBorder),
                    foregroundColor: AppColors.textPrimary,
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final Color dot;
  final String text;
  const _LocationRow({required this.dot, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dot),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppColors.grey),
          SizedBox(height: 16),
          Text('No orders available',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          SizedBox(height: 8),
          Text('Stay online to receive new orders',
              style: TextStyle(fontSize: 13, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final HomeController controller;
  const _BottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.selectedTab.value,
          onTap: (i) => controller.selectedTab.value = i,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart),
                label: 'Analytics'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile'),
          ],
        ));
  }
}
