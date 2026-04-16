import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../data/models/notification_model.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: Get.back,
        ),
        actions: [
          Obx(() {
            if (controller.unreadCount == 0) return const SizedBox.shrink();
            return TextButton(
              onPressed: controller.markAllRead,
              child: const Text('Mark all read',
                  style: TextStyle(color: AppColors.primary, fontSize: 13)),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (controller.notifications.isEmpty) {
          return const _EmptyNotifications();
        }
        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          color: AppColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) => _NotificationItem(
              notification: controller.notifications[i],
              onTap: () => controller.markRead(controller.notifications[i].id),
            ),
          ),
        );
      }),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  const _NotificationItem(
      {required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.white
              : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: notification.isRead
                  ? Colors.transparent
                  : AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.isRead
                    ? AppColors.greyLight
                    : AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: notification.isRead ? AppColors.grey : AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.w500
                            : FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 64, color: AppColors.grey),
          SizedBox(height: 16),
          Text('No notifications',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          SizedBox(height: 8),
          Text("You're all caught up!",
              style: TextStyle(fontSize: 13, color: AppColors.textHint)),
        ],
      ),
    );
  }
}
