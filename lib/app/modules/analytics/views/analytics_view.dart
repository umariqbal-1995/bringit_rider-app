import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  final bool embedded;
  const AnalyticsView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final content = Obx(() {
      if (controller.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: AppColors.primary));
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            const SizedBox(height: 20),
            _buildTotalEarningsCard(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSmallCard('Rs. ${controller.todayEarnings.value.toStringAsFixed(0)}', 'Today')),
                const SizedBox(width: 12),
                Expanded(child: _buildSmallCard('${controller.todayTrips.value} trips', '')),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Performance'),
            const SizedBox(height: 12),
            _buildPerformanceRow('Total Deliveries', '${controller.totalDeliveries.value}', Icons.delivery_dining),
            const Divider(color: AppColors.divider),
            _buildPerformanceRow('Rating', '4.9 ★', Icons.star_border),
            const Divider(color: AppColors.divider),
            _buildPerformanceRow('Acceptance Rate', '92%', Icons.check_circle_outline),
            const Divider(color: AppColors.divider),
            _buildPerformanceRow('Completion Rate', '98%', Icons.verified_outlined),
          ],
        ),
      );
    });

    if (embedded) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Analytics',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  Obx(() => _PeriodChip(
                        label: controller.selectedPeriod.value,
                        onTap: () => _showPeriodPicker(context),
                      )),
                ],
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
        title: const Text('Analytics'),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _PeriodChip(
                  label: controller.selectedPeriod.value,
                  onTap: () => _showPeriodPicker(context),
                ),
              )),
        ],
      ),
      body: content,
    );
  }

  Widget _buildPeriodSelector() => const SizedBox.shrink();

  Widget _buildTotalEarningsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Earned',
              style:
                  TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Obx(() => Text(
                'Rs. ${_formatNumber(controller.totalEarned.value)}',
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800),
              )),
          const SizedBox(height: 6),
          Obx(() => Row(
                children: [
                  Text(
                    '${controller.totalDeliveries.value} deliveries',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '↑ ${controller.weeklyGrowth.value.toStringAsFixed(0)}% vs last week',
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildSmallCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          if (label.isNotEmpty)
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary));
  }

  Widget _buildPerformanceRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary)),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  void _showPeriodPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.periods
              .map((p) => ListTile(
                    title: Text(p),
                    trailing: controller.selectedPeriod.value == p
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      controller.selectedPeriod.value = p;
                      Get.back();
                      controller.loadAnalytics();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  String _formatNumber(double n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}K';
    }
    return n.toStringAsFixed(0);
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PeriodChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 13, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
