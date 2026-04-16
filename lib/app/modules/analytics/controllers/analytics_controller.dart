import 'package:get/get.dart';
import '../../../data/repositories/rider_repository.dart';

class AnalyticsController extends GetxController {
  final RiderRepository _repo = RiderRepository();

  final isLoading = false.obs;
  final selectedPeriod = 'This Week'.obs;
  final totalEarned = 0.0.obs;
  final totalDeliveries = 0.obs;
  final todayEarnings = 0.0.obs;
  final todayTrips = 0.obs;
  final weeklyGrowth = 0.0.obs;

  final periods = ['Today', 'This Week', 'This Month', 'All Time'];

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    isLoading.value = true;
    try {
      final data = await _repo.getAnalyticsOverview();
      totalEarned.value = (data['totalEarned'] as num?)?.toDouble() ?? 14250.0;
      totalDeliveries.value = (data['totalDeliveries'] as num?)?.toInt() ?? 38;
      todayEarnings.value = (data['todayEarnings'] as num?)?.toDouble() ?? 2100.0;
      todayTrips.value = (data['todayTrips'] as num?)?.toInt() ?? 8;
      weeklyGrowth.value = (data['weeklyGrowth'] as num?)?.toDouble() ?? 18.0;
    } catch (_) {
      // Keep defaults for demo
      totalEarned.value = 14250.0;
      totalDeliveries.value = 38;
      todayEarnings.value = 2100.0;
      todayTrips.value = 8;
      weeklyGrowth.value = 18.0;
    }
    isLoading.value = false;
  }
}
