class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api/v1';

  // Replace with a key that has Directions API enabled
  static const String googleMapsApiKey = 'AIzaSyABCDEFGHIJKLMNOPQRSTUVWXYZ012345';

  // Rider Auth
  static const String riderLogin = '/rider/auth/login';
  static const String riderRefreshToken = '/rider/auth/refresh-token';

  // Rider Profile
  static const String riderMe = '/rider/me';
  static const String riderAvailability = '/rider/availability';

  // Rider Location
  static const String riderLocation = '/rider/location';

  // Rider Orders
  static const String riderOrdersAssigned = '/rider/orders/assigned';
  static String riderOrder(String id) => '/rider/orders/$id';
  static String riderOrderAccept(String id) => '/rider/orders/$id/accept';
  static String riderOrderPickup(String id) => '/rider/orders/$id/pickup';
  static String riderOrderStartDelivery(String id) => '/rider/orders/$id/start-delivery';
  static String riderOrderComplete(String id) => '/rider/orders/$id/complete';
  static String riderOrderCancel(String id) => '/rider/orders/$id/cancel';

  // Rider Earnings
  static const String riderEarningsSummary = '/rider/earnings/summary';
  static const String riderEarningsHistory = '/rider/earnings/history';

  // Rider Analytics
  static const String riderAnalyticsOverview = '/rider/analytics/overview';
  static const String riderAnalyticsEarnings = '/rider/analytics/earnings';
  static const String riderAnalyticsDeliveries = '/rider/analytics/deliveries';
  static const String riderAnalyticsPerformance = '/rider/analytics/performance';

  // Rider Notifications
  static const String riderNotifications = '/rider/notifications';
  static String riderNotificationRead(String id) => '/rider/notifications/$id/read';
  static const String riderNotificationsReadAll = '/rider/notifications/read-all';
}

class StorageKeys {
  static const String riderToken = 'rider_token';
  static const String riderData = 'rider_data';
}
