import '../models/order_model.dart';
import '../models/rider_model.dart';
import '../models/notification_model.dart';
import '../providers/api_provider.dart';
import '../../utils/constants.dart';

class RiderRepository {
  final ApiProvider _api = ApiProvider();

  // Auth
  Future<void> sendOtp(String phone) async {
    await _api.post(ApiConstants.riderLogin, body: {'phone': phone}, auth: false);
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    return _api.post(
      ApiConstants.riderRefreshToken,
      body: {'phone': phone, 'otp': otp},
      auth: false,
    );
  }

  // Profile
  Future<RiderModel> getMe() async {
    final res = await _api.get(ApiConstants.riderMe);
    return RiderModel.fromJson(res['data'] ?? res);
  }

  Future<RiderModel> updateMe(Map<String, dynamic> data) async {
    final res = await _api.put(ApiConstants.riderMe, body: data);
    return RiderModel.fromJson(res['data'] ?? res);
  }

  Future<void> updateAvailability(bool isAvailable) async {
    await _api.put(ApiConstants.riderAvailability, body: {'isAvailable': isAvailable});
  }

  // Location
  Future<void> updateLocation(double lat, double lng) async {
    await _api.post(ApiConstants.riderLocation, body: {'lat': lat, 'lng': lng});
  }

  // Orders
  Future<List<OrderModel>> getAssignedOrders() async {
    final res = await _api.get(ApiConstants.riderOrdersAssigned);
    final list = res['data'] as List<dynamic>? ?? [];
    return list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OrderModel> getOrder(String id) async {
    final res = await _api.get(ApiConstants.riderOrder(id));
    return OrderModel.fromJson(res['data'] ?? res);
  }

  Future<void> acceptOrder(String id) async {
    await _api.post(ApiConstants.riderOrderAccept(id));
  }

  Future<void> pickupOrder(String id) async {
    await _api.post(ApiConstants.riderOrderPickup(id));
  }

  Future<void> startDelivery(String id) async {
    await _api.post(ApiConstants.riderOrderStartDelivery(id));
  }

  Future<void> completeOrder(String id) async {
    await _api.post(ApiConstants.riderOrderComplete(id));
  }

  Future<void> cancelOrder(String id) async {
    await _api.post(ApiConstants.riderOrderCancel(id));
  }

  // Earnings
  Future<EarningsSummary> getEarningsSummary() async {
    final res = await _api.get(ApiConstants.riderEarningsSummary);
    return EarningsSummary.fromJson(res['data'] ?? res);
  }

  Future<List<Map<String, dynamic>>> getEarningsHistory() async {
    final res = await _api.get(ApiConstants.riderEarningsHistory);
    final list = res['data'] as List<dynamic>? ?? [];
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  // Analytics
  Future<Map<String, dynamic>> getAnalyticsOverview() async {
    final res = await _api.get(ApiConstants.riderAnalyticsOverview);
    return res['data'] ?? res;
  }

  // Notifications
  Future<List<NotificationModel>> getNotifications() async {
    final res = await _api.get(ApiConstants.riderNotifications);
    final list = res['data'] as List<dynamic>? ?? [];
    return list.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> markNotificationRead(String id) async {
    await _api.put(ApiConstants.riderNotificationRead(id));
  }

  Future<void> markAllNotificationsRead() async {
    await _api.put(ApiConstants.riderNotificationsReadAll);
  }
}
