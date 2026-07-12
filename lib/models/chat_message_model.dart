/// Represents a single part (usually text) within a message.
class MessagePart {
  final String text;
  final String? thoughtSignature;

  MessagePart({
    required this.text,
    this.thoughtSignature,
  });

  factory MessagePart.fromJson(Map<String, dynamic> json) {
    return MessagePart(
      text: json['text'] as String? ?? '',
      thoughtSignature: json['thoughtSignature'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (thoughtSignature != null) 'thoughtSignature': thoughtSignature,
    };
  }
}

/// Represents the content of a message containing multiple parts.
class MessageContent {
  final List<MessagePart> parts;
  final String role; // "user" or "model"

  MessageContent({
    required this.parts,
    required this.role,
  });

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    final partsList = (json['parts'] as List?)
        ?.map((p) => MessagePart.fromJson(p as Map<String, dynamic>))
        .toList() ?? [];

    return MessageContent(
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

/// Represents a single chat message.
class ChatMessageModel {
  final MessageContent content;
  final String? finishReason;
  final int? index;

  ChatMessageModel({
    required this.content,
    this.finishReason,
    this.index,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      content: MessageContent.fromJson(json['content'] as Map<String, dynamic>),
      finishReason: json['finishReason'] as String?,
      index: json['index'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.toJson(),
      if (finishReason != null) 'finishReason': finishReason,
      if (index != null) 'index': index,
    };
  }

  /// Extracts the first text from the message's parts.
  String get getText {
    if (content.parts.isNotEmpty) {
      return content.parts.first.text;
    }
    return '';
  }
}
