/// Represents a single part (usually text) within a message.
class MessagePartModel {
  final String text;
  final String? thoughtSignature;

  MessagePartModel({
    required this.text,
    this.thoughtSignature,
  });

  factory MessagePartModel.fromJson(Map<String, dynamic> json) {
    return MessagePartModel(
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