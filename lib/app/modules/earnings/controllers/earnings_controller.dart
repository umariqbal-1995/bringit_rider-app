import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/rider_repository.dart';

class EarningsController extends GetxController {
  final RiderRepository _repo = RiderRepository();

  final isLoading = false.obs;
  final summary = Rxn<EarningsSummary>();
  final history = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEarnings();
  }

  Future<void> loadEarnings() async {
    isLoading.value = true;
    try {
      summary.value = await _repo.getEarningsSummary();
      history.value = await _repo.getEarningsHistory();
    } catch (_) {
      summary.value = EarningsSummary(
        today: 2100,
        thisWeek: 12500,
        thisMonth: 38000,
        total: 14250,
        totalDeliveries: 38,
      );
    }
    isLoading.value = false;
  }
}
