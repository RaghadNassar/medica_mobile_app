import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, audio, file }
enum MessageStatus { sending, sent, delivered, read }

class MessageModel {
  final String? messageId; 
  final String senderId;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final String? fileUrl;
  final MessageStatus status;

  MessageModel({
    this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.fileUrl,
    this.status = MessageStatus.sending,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      messageId: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] != null 
          ? (data['timestamp'] as Timestamp).toDate() 
          : DateTime.now(),
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => MessageType.text,
      ),
      fileUrl: data['fileUrl'],
      status: MessageStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => MessageStatus.sent,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(), // الفايربيز يضع الوقت تلقائياً من السيرفر
      'type': type.toString().split('.').last,
      'fileUrl': fileUrl,
      'status': status.toString().split('.').last,
    };
  }
}