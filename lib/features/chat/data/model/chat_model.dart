class ChatListItem {
  final String id;
  final String name;
  final String role; // سيمثل التخصص للطبيب، أو الدور الحقيقي للمستخدمين الآخرين
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final bool isActive; 

  ChatListItem({
    required this.id,
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    required this.unreadCount,
    this.isActive = false,
  });

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    String rawRole = json['role'] ?? '';
    String displayRole = rawRole;

    // 🎯 التعديل الجوهري الخاص بزميلكِ: استخراج اسم التخصص إذا كان الحساب لطبيب
    if (rawRole == 'doctor' && json['doctor'] != null && json['doctor']['specialization'] != null) {
      displayRole = json['doctor']['specialization']['name'] ?? 'طبيب';
    } else if (rawRole == 'secretary') {
      displayRole = 'سكرتارية';
    } else if (rawRole == 'patient') {
      displayRole = 'مريض';
    }

    // معالجة الصور
    String img = json['image_url'] ?? '';

    return ChatListItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      role: displayRole, 
      lastMessage: json['last_message'] ?? 'اضغط لبدء محادثة جديدة',
      time: json['time'] ?? '',
      avatarUrl: img, 
      unreadCount: json['unread_count'] ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }

  // سنحتاجها إذا أردتِ كشنتها لاحقاً
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'last_message': lastMessage,
      'time': time,
      'image_url': avatarUrl,
      'unread_count': unreadCount,
      'is_active': isActive,
    };
  }
}