import 'package:raghad_pro/core/api/end_point.dart';
class ErrorModel {
  final bool success;
  final String message;
  final dynamic errors;

  ErrorModel({
    required this.success,
    required this.message,
    this.errors,
  });

  factory ErrorModel.fromLocalError(String localMessage) {
    return ErrorModel(
      success: false,
      message: localMessage,
      errors: null,
    );
  }

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    String extractedMessage =
        json[ApiKey.message] ?? 'حدث خطأ ما، يرجى المحاولة لاحقاً';

    if (json[ApiKey.errors] != null) {
      if (json[ApiKey.errors] is Map) {
        final Map<String, dynamic> validationErrors = json[ApiKey.errors];
        if (validationErrors.isNotEmpty) {
          final firstKey = validationErrors.keys.first;
          if (validationErrors[firstKey] is List &&
              (validationErrors[firstKey] as List).isNotEmpty) {
            extractedMessage = validationErrors[firstKey][0].toString();
          } else if (validationErrors[firstKey] is String) {
            extractedMessage = validationErrors[firstKey];
          }
        }
      } else if (json[ApiKey.errors] is List && (json[ApiKey.errors] as List).isNotEmpty) {
        extractedMessage = json[ApiKey.errors][0].toString();
      }
    }

    return ErrorModel(
      success: json[ApiKey.success] ?? false,
      message: extractedMessage,
      errors: json[ApiKey.errors],
    );
  }
}





































































































/*
class ErrorModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? errors;

  ErrorModel({
    required this.success,
    required this.message,
    this.errors,
  });

  factory ErrorModel.fromLocalError(String localMessage) {
    return ErrorModel(
      success: false,
      message: localMessage,
      errors: null,
    );
  }

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    String extractedMessage =
        json[ApiKey.message] ?? 'حدث خطأ ما، يرجى المحاولة لاحقاً';

    if (json[ApiKey.errors] != null && json[ApiKey.errors] is Map) {
      final Map<String, dynamic> validationErrors = json[ApiKey.errors];

      if (validationErrors.isNotEmpty) {
        final firstKey = validationErrors.keys.first;

        if (validationErrors[firstKey] is List &&
            (validationErrors[firstKey] as List).isNotEmpty) {
          extractedMessage = validationErrors[firstKey][0].toString();
        }
      }
    }

    return ErrorModel(
      success: json[ApiKey.success] ?? false,
      message: extractedMessage,
      errors: json[ApiKey.errors],
    );
  }
}*/
