class AppNotification {
  final String uuid;
  final String title;
  final String body;
  final String? extraData;
  final String type;
  bool isRead; // متغير لتغيير حالته في الواجهة فوراً
  final String createdAt;

  AppNotification({
    required this.uuid,
    required this.title,
    required this.body,
    this.extraData,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      uuid: json['uuid']?.toString() ?? '',
      title: json['title']?.toString() ?? 'إشعار جديد',
      body: json['body']?.toString() ?? '',
      extraData: json['extra_data']?.toString(),
      type: json['type']?.toString() ?? 'GeneralNotification',
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}