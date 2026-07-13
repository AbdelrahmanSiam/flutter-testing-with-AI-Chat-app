import 'package:ai_chat_app/models/message_content_model.dart';
import 'package:ai_chat_app/models/message_part_model.dart';

/// Represents a single chat message.
class ChatMessageModel {
  final MessageContentModel content;
  final String? finishReason;
  final int? index;

  ChatMessageModel({required this.content, this.finishReason, this.index});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      content: MessageContentModel.fromJson(
        json['content'] as Map<String, dynamic>,
      ),
      finishReason: json['finishReason'] as String?,
      index: json['index'] as int?,
    );
  }

  factory ChatMessageModel.user(String text) {
    return ChatMessageModel(
      content: MessageContentModel(
        parts: [MessagePartModel(text: text)],
        role: 'user',
      ),
    );
  }

  factory ChatMessageModel.model(String text) {
    return ChatMessageModel(
      content: MessageContentModel(
        parts: [MessagePartModel(text: text)],
        role: 'model',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.toJson(),
      if (finishReason != null) 'finishReason': finishReason,
      if (index != null) 'index': index,
    };
  }
}
