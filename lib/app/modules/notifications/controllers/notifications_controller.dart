import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/rider_repository.dart';

class NotificationsController extends GetxController {
  final RiderRepository _repo = RiderRepository();

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      notifications.value = await _repo.getNotifications();
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> markRead(String id) async {
    try {
      await _repo.markNotificationRead(id);
      final idx = notifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        notifications[idx] = NotificationModel(
          id: notifications[idx].id,
          title: notifications[idx].title,
          body: notifications[idx].body,
          isRead: true,
          createdAt: notifications[idx].createdAt,
        );
        notifications.refresh();
      }
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _repo.markAllNotificationsRead();
      await loadNotifications();
    } catch (_) {}
  }
}
