import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../controllers/earnings_controller.dart';

class EarningsView extends GetView<EarningsController> {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Earnings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final s = controller.summary.value;
        return RefreshIndicator(
          onRefresh: controller.loadEarnings,
          color: AppColors.primary,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(s?.today ?? 0, s?.thisWeek ?? 0,
                    s?.thisMonth ?? 0, s?.totalDeliveries ?? 0),
                const SizedBox(height: 24),
                const Text('Earnings History',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                if (controller.history.isEmpty)
                  const _EmptyHistory()
                else
                  ...controller.history
                      .map((h) => _HistoryItem(data: h)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards(
      double today, double week, double month, int deliveries) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Earnings',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              Text(
                'Rs. ${(today + week).toStringAsFixed(0)}',
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text('$deliveries deliveries completed',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _EarningCard(
                  label: 'Today', value: 'Rs. ${today.toStringAsFixed(0)}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _EarningCard(
                  label: 'This Week',
                  value: 'Rs. ${week.toStringAsFixed(0)}'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _EarningCard(
            label: 'This Month',
            value: 'Rs. ${month.toStringAsFixed(0)}',
            fullWidth: true),
      ],
    );
  }
}

class _EarningCard extends StatelessWidget {
  final String label;
  final String value;
  final bool fullWidth;

  const _EarningCard(
      {required this.label, required this.value, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const _HistoryItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                const Icon(Icons.delivery_dining, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['orderNumber']?.toString() ?? 'Order',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary)),
                Text(data['date']?.toString() ?? '',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            'Rs. ${data['earning']?.toString() ?? '0'}',
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.grey),
            SizedBox(height: 12),
            Text('No earnings history yet',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
