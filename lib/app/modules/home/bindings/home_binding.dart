import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../analytics/controllers/analytics_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<AnalyticsController>(() => AnalyticsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
