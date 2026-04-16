class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['_id'] ?? json['id'] ?? '',
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        isRead: json['isRead'] ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
}

class EarningsSummary {
  final double today;
  final double thisWeek;
  final double thisMonth;
  final double total;
  final int totalDeliveries;

  EarningsSummary({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.total,
    required this.totalDeliveries,
  });

  factory EarningsSummary.fromJson(Map<String, dynamic> json) =>
      EarningsSummary(
        today: (json['today'] as num?)?.toDouble() ?? 0.0,
        thisWeek: (json['thisWeek'] as num?)?.toDouble() ?? 0.0,
        thisMonth: (json['thisMonth'] as num?)?.toDouble() ?? 0.0,
        total: (json['total'] as num?)?.toDouble() ?? 0.0,
        totalDeliveries: (json['totalDeliveries'] as num?)?.toInt() ?? 0,
      );
}
