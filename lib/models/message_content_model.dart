import 'package:ai_chat_app/models/message_part_model.dart';

/// Represents the content of a message containing multiple parts.
class MessageContentModel {
  final List<MessagePartModel> parts;
  final String role; // "user" or "model"

  MessageContentModel({
    required this.parts,
    required this.role,
  });

  factory MessageContentModel.fromJson(Map<String, dynamic> json) {
    final partsList = (json['parts'] as List?)
        ?.map((p) => MessagePartModel.fromJson(p as Map<String, dynamic>))
        .toList() ?? [];

    return MessageContentModel(
      parts: partsList,
      role: json['role'] as String? ?? 'user',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'parts': parts.map((p) => p.toJson()).toList(),
      'role': role,
    };
  }
}